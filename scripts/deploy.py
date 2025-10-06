"""
Automates Terraform deployment from YAML configuration with safety checks
"""

import yaml
import json
import subprocess
import sys
import argparse
import logging
from pathlib import Path
from datetime import datetime
from typing import Optional

# Configure logging
logging_dir = Path(__file__).parent / "logs"
logging_dir.mkdir(exist_ok=True)

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

log_fmt = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

file_handler = logging.FileHandler(
    f'{logging_dir}/deploy_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log'
)
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(log_fmt)
logger.addHandler(file_handler)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
console_handler.setFormatter(log_fmt)
logger.addHandler(console_handler)


class TerraformDeployer:
    """Handles Terraform deployment operations"""

    def __init__(self, config_file: str, workspace: Optional[str] = None,
                 auto_approve: bool = False):
        self.config_file = Path(config_file)
        self.workspace = workspace
        self.auto_approve = auto_approve
        self.script_dir = Path(__file__).parent
        self.root_dir = self.script_dir.parent
        self.tfvars_file = self.root_dir / "terraform.tfvars"
        self.backends_dir = self.root_dir / "backends"
        self.config = None

    def validate_prerequisites(self) -> bool:
        """Validate required tools and files exist"""
        logger.debug("Validating prerequisites...")

        # Check config file exists
        if not self.config_file.exists():
            logger.error(f"Config file not found: {self.config_file}")
            return False

        logger.debug(f"Config file found: {self.config_file}")

        return True

    def load_yaml_config(self) -> bool:
        """Load and validate YAML configuration"""
        logger.debug(f"Loading configuration from {self.config_file}")

        try:
            with open(self.config_file, 'r') as f:
                self.config = yaml.safe_load(f)

            # Validate required fields
            required_fields = ['project_id', 'billing_account']
            missing_fields = [
                field for field in required_fields if field not in self.config]

            if missing_fields:
                logger.error(
                    f"Missing required fields: {', '.join(missing_fields)}")
                return False

            logger.info(f"Configuration loaded successfully")
            logger.info(f"  Project ID: {self.config['project_id']}")

            return True

        except yaml.YAMLError as e:
            logger.error(f"YAML parsing error: {e}")
            return False
        except Exception as e:
            logger.error(f"Error loading config: {e}")
            return False

    def generate_tfvars(self) -> bool:
        """Generate Terraform variables file from YAML config"""
        logger.debug(f"Generating {self.tfvars_file}")

        try:
            with open(self.tfvars_file, 'w') as f:
                for key, value in self.config.items():
                    if isinstance(value, (dict, list)):
                        f.write(f'{key} = {json.dumps(value, indent=2)}\n\n')
                    elif isinstance(value, str):
                        f.write(f'{key} = "{value}"\n')
                    elif isinstance(value, bool):
                        f.write(f'{key} = {str(value).lower()}\n')
                    else:
                        f.write(f'{key} = {value}\n')

            logger.debug(f"Generated {self.tfvars_file}")
            return True

        except Exception as e:
            logger.error(f"Error generating tfvars: {e}")
            return False

    def generate_backend_config(self) -> Path:
        """Generate unique backend config with smart defaults"""
        logger.debug("Generating backend configuration")

        self.backends_dir.mkdir(exist_ok=True)

        # Defaults if not specified in YAML
        default_bucket = f"konecta-autogcp-terraform-state-bucket"
        default_prefix = f"projects/{self.config['project_id']}"

        # Use config values or fall back to defaults
        state_bucket = self.config.get(
            'terraform_state_bucket', default_bucket)
        state_prefix = self.config.get(
            'terraform_state_prefix', default_prefix)

        backend_file = self.backends_dir / \
            f"{self.config['project_id']}.backend.conf"

        backend_config = f'bucket = "{state_bucket}"\nprefix = "{state_prefix}"'

        with open(backend_file, 'w') as f:
            f.write(backend_config)

        logger.debug(f"Backend config created: {backend_file}")
        logger.debug(f"Bucket: {state_bucket}")
        logger.debug(f"Prefix: {state_prefix}")

        # Warn if using defaults
        if 'terraform_state_bucket' not in self.config:
            logger.warning(f"Using default bucket: {state_bucket}")

        if 'terraform_state_prefix' not in self.config:
            logger.debug(f"Using default prefix: {state_prefix}")

        logger.info(
            f"State location: gs://{state_bucket}/{state_prefix}/default.tfstate")

        return backend_file

    def run_terraform_command(self, command: list, check: bool = True) -> bool:
        """Execute Terraform command with error handling"""
        cmd_str = ' '.join(command)
        logger.info(f"Running: terraform {cmd_str}")

        try:
            result = subprocess.run(
                ['terraform'] + command,
                cwd=self.root_dir,
                capture_output=True,
                text=True,
                check=check
            )

            if result.stdout:
                for line in result.stdout.splitlines():
                    logger.info(f"   {line}")

            if result.returncode == 0:
                logger.info(f"Command completed successfully")
                return True
            else:
                if result.stderr:
                    for line in result.stderr.splitlines():
                        logger.error(f"   {line}")
                logger.error(
                    f"Command failed with exit code {result.returncode}")
                return False

        except subprocess.CalledProcessError as e:
            logger.error(f"Terraform command failed: {e}")
            if e.stderr:
                logger.error(e.stderr)
            return False
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return False

    def select_workspace(self) -> bool:
        """Select or create Terraform workspace"""
        if not self.workspace:
            logger.info("Using default workspace")
            return True

        logger.info(f"Selecting workspace: {self.workspace}")

        # List existing workspaces
        result = subprocess.run(
            ['terraform', 'workspace', 'list'],
            cwd=self.root_dir,
            capture_output=True,
            text=True
        )

        if self.workspace in result.stdout:
            return self.run_terraform_command(['workspace', 'select', self.workspace])
        else:
            logger.info(f"Creating new workspace: {self.workspace}")
            return self.run_terraform_command(['workspace', 'new', self.workspace])

    def deploy(self) -> bool:
        """Execute full deployment workflow"""
        logger.info("=" * 70)
        logger.info("Starting AutoGCP Deployment")
        logger.info("=" * 70)

        # Step 1: Validate prerequisites
        if not self.validate_prerequisites():
            return False

        # Step 2: Load configuration
        if not self.load_yaml_config():
            return False

        # Step 3: Generate tfvars
        if not self.generate_tfvars():
            return False

        # Step 4: Initialize Terraform
        logger.info("\n" + "=" * 70)
        logger.info("Initializing Terraform")
        logger.info("=" * 70)
        backend_config_file = self.generate_backend_config()
        if not self.run_terraform_command([
            'init',
            '-reconfigure',
            f'-backend-config={backend_config_file}'
        ]):
            return False

        # Step 5: Select workspace
        if not self.select_workspace():
            return False

        # Step 6: Validate configuration
        logger.info("\n" + "=" * 70)
        logger.info("Validating Configuration")
        logger.info("=" * 70)
        if not self.run_terraform_command(['validate']):
            return False

        # Step 7: Format step
        logger.info("\n" + "=" * 70)
        logger.info("Formatting Code")
        logger.info("=" * 70)
        self.run_terraform_command(['fmt', '-recursive'], check=False)

        # Step 8: Plan
        logger.info("\n" + "=" * 70)
        logger.info("Creating Execution Plan")
        logger.info("=" * 70)
        if not self.run_terraform_command(['plan', '-out=tfplan']):
            return False

        # Step 9: Review and apply
        logger.info("\n" + "=" * 70)
        logger.info("Ready to Apply Changes")
        logger.info("=" * 70)

        if not self.auto_approve:
            logger.info("Please review the plan above.")
            response = input(
                "\nApply these changes? (yes/no): ").strip().lower()
            if response != 'yes':
                logger.info("Deployment cancelled by user")
                return False

        logger.info("Applying infrastructure changes...")
        if not self.run_terraform_command(['apply', 'tfplan']):
            return False

        # Step 10: Show outputs
        logger.info("\n" + "=" * 70)
        logger.info("Deployment Outputs")
        logger.info("=" * 70)
        self.run_terraform_command(['output'])

        logger.info("\n" + "=" * 70)
        logger.info("Deployment Completed Successfully!")
        logger.info("=" * 70)

        return True


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description='Deploy GCP infrastructure using Terraform and YAML configuration',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python deploy.py config.yaml
  python deploy.py config.yaml --workspace dev --auto-approve
  python deploy.py config.yaml --workspace prod --quiet
        """
    )

    parser.add_argument(
        'config',
        help='Path to YAML configuration file'
    )

    parser.add_argument(
        '-w', '--workspace',
        help='Terraform workspace to use',
        default=None
    )

    parser.add_argument(
        '-a', '--auto-approve',
        help='Skip interactive approval',
        action='store_true'
    )

    verbosity_group = parser.add_mutually_exclusive_group()

    verbosity_group.add_argument(
        '-v', '--verbose',
        help='Enable verbose/debug logging',
        action='store_true'
    )

    verbosity_group.add_argument(
        '-q', '--quiet',
        help='Quiet mode - only warnings and errors',
        action='store_true'
    )

    args = parser.parse_args()

    if args.quiet:
        console_handler.setLevel(logging.WARNING)
    elif args.verbose:
        console_handler.setLevel(logging.DEBUG)
    else:
        console_handler.setLevel(logging.INFO)

    # Create deployer instance
    deployer = TerraformDeployer(
        config_file=args.config,
        workspace=args.workspace,
        auto_approve=args.auto_approve,
    )

    # Execute deployment
    try:
        success = deployer.deploy()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        logger.warning("\nDeployment interrupted by user")
        sys.exit(130)
    except Exception as e:
        logger.exception(f"Unexpected error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
