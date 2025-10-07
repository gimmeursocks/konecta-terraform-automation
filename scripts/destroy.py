"""
Safely destroys Terraform-managed infrastructure with multiple safety checks.
"""

import yaml
import subprocess
import sys
import os
import argparse
import logging
import time
from pathlib import Path
from datetime import datetime
from typing import List, Optional


# Configure logging
logging_dir = Path(__file__).parent / "logs"
logging_dir.mkdir(exist_ok=True)

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

log_fmt = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

file_handler = logging.FileHandler(
    f'{logging_dir}/destroy_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log'
)
file_handler.setLevel(logging.DEBUG)
file_handler.setFormatter(log_fmt)
logger.addHandler(file_handler)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
console_handler.setFormatter(log_fmt)
logger.addHandler(console_handler)


class TerraformDestroyer:
    """Handles Terraform destroy operations with safety checks"""

    def __init__(self, config_file: Optional[str] = None, workspace: Optional[str] = None,
                 auto_approve: bool = False, target: Optional[List[str]] = None):
        self.config_file = Path(config_file)
        self.workspace = workspace
        self.auto_approve = auto_approve
        self.targets = target or []
        self.script_dir = Path(__file__).parent
        self.root_dir = self.script_dir.parent
        self.backends_dir = self.root_dir / "backends"
        self.project_id = None

    def validate_prerequisites(self) -> bool:
        """Validate required tools and state"""
        logger.debug("Validating prerequisites...")

        # Check if Terraform is initialized
        terraform_dir = self.root_dir / ".terraform"
        if not terraform_dir.exists():
            logger.error(
                "Terraform not initialized. Run 'terraform init' first.")
            return False

        logger.debug("Terraform is initialized")

        # Check if state file exists
        state_file = self.root_dir / "terraform.tfstate"
        if not state_file.exists():
            logger.warning("No local state file found")
            logger.debug("Checking for remote state...")

        # Check GCP credentials
        if not os.getenv('GOOGLE_APPLICATION_CREDENTIALS'):
            logger.warning(
                "GOOGLE_APPLICATION_CREDENTIALS env not set. Using default credentials.")
        else:
            logger.info("GCP credentials configured")

        return True

    def load_yaml_config(self) -> bool:
        """Load and validate YAML configuration"""
        logger.debug(f"Loading configuration from {self.config_file}")

        try:
            with open(self.config_file, 'r') as f:
                self.config = yaml.safe_load(f)

            # Validate required fields
            required_fields = ['project_id']
            missing_fields = [
                field for field in required_fields if field not in self.config]

            if missing_fields:
                logger.error(
                    f"Missing required fields: {', '.join(missing_fields)}")
                return False

            self.project_id = self.config['project_id']

            logger.info(f"Configuration loaded successfully")
            logger.info(f"  Project ID: {self.config['project_id']}")
            return True

        except yaml.YAMLError as e:
            logger.error(f"YAML parsing error: {e}")
            return False
        except Exception as e:
            logger.error(f"Error loading config: {e}")
            return False

    def get_resource_count(self) -> int:
        """Get count of resources to be destroyed"""
        try:
            result = subprocess.run(
                ['terraform', 'state', 'list'],
                cwd=self.root_dir,
                capture_output=True,
                text=True,
                check=True
            )
            resources = [line for line in result.stdout.splitlines()
                         if line.strip()]
            return len(resources)
        except Exception:
            return 0

    def show_resources(self) -> int:
        """Display resources that will be destroyed"""
        logger.info("=" * 70)
        logger.info("Resources to be destroyed:")
        logger.info("=" * 70)

        try:
            result = subprocess.run(
                ['terraform', 'state', 'list'],
                cwd=self.root_dir,
                capture_output=True,
                text=True,
                check=True
            )

            resources = [line for line in result.stdout.splitlines()
                         if line.strip()]
            for i, resource in enumerate(resources, 1):
                logger.info(f"  {i}. {resource}")

            logger.info(f"\n  Total resources: {len(resources)}")

            return len(resources)

        except Exception as e:
            logger.error(f"Failed to list resources: {e}")

    def generate_backend_config(self) -> Path:
        """Generate unique backend config with smart defaults"""
        logger.debug("Generating backend configuration")

        self.backends_dir.mkdir(exist_ok=True)

        # Defaults if not specified in YAML
        default_bucket = "konecta-autogcp-terraform-state-bucket"
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
        """Execute Terraform command"""
        cmd_str = ' '.join(command)
        logger.info(f"Running: terraform {cmd_str}")

        try:
            if "destroy.tfplan" in command:
                process = subprocess.Popen(
                    ['terraform'] + command,
                    cwd=self.root_dir,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    bufsize=1
                )
                for line in process.stdout:
                    # stream directly to console
                    logger.info(f"   {line.strip()}")
                process.wait()

                if process.returncode == 0:
                    logger.info("Command completed successfully")
                    return True
                else:
                    logger.error(
                        f"Command failed with exit code {process.returncode}")
                    return False
            else:
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

        except Exception as e:
            logger.error(f"Command execution error: {e}")
            return False

    def select_workspace(self) -> bool:
        """Select Terraform workspace"""
        if not self.workspace:
            logger.info("Using default workspace")
            result = subprocess.run(
                ['terraform', 'workspace', 'show'],
                cwd=self.root_dir,
                capture_output=True,
                text=True
            )
            current_workspace = result.stdout.strip()
            logger.debug(f"Current workspace: {current_workspace}")
            return True

        logger.info(f"Selecting workspace: {self.workspace}")
        return self.run_terraform_command(['workspace', 'select', self.workspace])

    def confirm_destruction(self) -> bool:
        """Multi-step confirmation process for destruction"""
        logger.warning("\n" + "!" * 70)
        logger.warning("DANGER: DESTRUCTIVE OPERATION")
        logger.warning("!" * 70)

        resource_count = self.get_resource_count()

        if self.project_id:
            logger.warning(f"  Project: {self.project_id}")
        if self.workspace:
            logger.warning(f"  Workspace: {self.workspace}")
        logger.warning(f"  Resources to destroy: {resource_count}")

        if self.targets:
            logger.warning(f"  Targeted resources: {', '.join(self.targets)}")
        else:
            logger.warning("  ALL resources will be destroyed")

        logger.warning("\nThis action CANNOT be undone!")
        logger.warning("All infrastructure will be permanently deleted!")

        # First confirmation
        logger.info("\n" + "-" * 70)
        response1 = input(
            "Type 'destroy' to confirm you want to proceed: ").strip()
        if response1 != 'destroy':
            logger.info("Destruction cancelled")
            return False

        # Second confirmation with project ID
        if self.project_id:
            logger.info("\n" + "-" * 70)
            response2 = input(
                f"Type the project ID '{self.project_id}' to confirm: ").strip()
            if response2 != self.project_id:
                logger.info("Project ID mismatch. Destruction cancelled")
                return False

        # Final countdown
        logger.warning("\nStarting destruction in 5 seconds...")
        logger.warning("   Press Ctrl+C to abort")
        try:
            for i in range(5, 0, -1):
                logger.warning(f"   {i}...")
                time.sleep(1)
        except KeyboardInterrupt:
            logger.info("\nDestruction cancelled by user")
            return False

        return True

    def destroy(self) -> bool:
        """Execute infrastructure destruction"""
        logger.info("=" * 70)
        logger.info("Starting Infrastructure Destruction")
        logger.info("=" * 70)

        # Step 1: Validate prerequisites
        if not self.validate_prerequisites():
            return False

        # Step 2: Load configuration
        if not self.load_yaml_config():
            return False

        # Step 3: Initialize Terraform
        logger.info("=" * 70)
        logger.info("Initializing Terraform")
        logger.info("=" * 70)
        backend_config_file = self.generate_backend_config()
        if not self.run_terraform_command([
            'init',
            '-reconfigure',
            f'-backend-config={backend_config_file}'
        ]):
            return False

        # Step 4: Select workspace
        if not self.select_workspace():
            return False

        # Step 5: Show resources
        if self.show_resources() == 0:
            logger.info("Nothing to destroy")
            return False

        # Step 6: Generate destroy plan
        logger.info("=" * 70)
        logger.info("Generating Destruction Plan")
        logger.info("=" * 70)

        plan_cmd = ['plan', '-destroy', '-out=destroy.tfplan']
        for target in self.targets:
            plan_cmd.extend(['-target', target])

        if not self.run_terraform_command(plan_cmd):
            return False

        # Step 7: Confirm destruction
        if not self.auto_approve:
            if not self.confirm_destruction():
                return False
        else:
            logger.warning("Auto-approve enabled, skipping confirmation")

        # Step 8: Execute destruction
        logger.info("=" * 70)
        logger.info("Destroying Infrastructure")
        logger.info("=" * 70)

        destroy_cmd = ['apply', 'destroy.tfplan']
        if not self.run_terraform_command(destroy_cmd):
            logger.error("Destruction failed!")
            logger.error(
                "Some resources may still exist. Please check manually.")
            return False

        # Step 9: Verify destruction
        logger.info("=" * 70)
        logger.info("Verifying Destruction")
        logger.info("=" * 70)

        remaining_resources = self.get_resource_count()
        if remaining_resources > 0:
            logger.warning(
                f"{remaining_resources} resources still exist in state")
            logger.warning("   Manual cleanup may be required")
        else:
            logger.info("All resources destroyed successfully")

        logger.info("=" * 70)
        logger.info("Destruction Process Completed")
        logger.info("=" * 70)

        return True


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description='Safely destroy Terraform-managed GCP infrastructure',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python destroy.py config.yaml
  python destroy.py config.yaml --workspace dev --auto-approve
  python destroy.py config.yaml --workspace prod --quiet
        """
    )

    parser.add_argument(
        'config',
        help='Path to YAML configuration file'
    )

    parser.add_argument(
        '-w', '--workspace',
        help='Terraform workspace to destroy',
        default=None
    )

    parser.add_argument(
        '-t', '--target',
        help='Destroy specific resource (can be used multiple times)',
        action='append',
        dest='targets'
    )

    parser.add_argument(
        '-a', '--auto-approve',
        help='Skip interactive approval (DANGEROUS)',
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

    # Warning for auto-approve
    if args.auto_approve:
        logger.warning("AUTO-APPROVE MODE ENABLED")
        logger.warning("This will destroy resources without confirmation!")

    # Create destroyer instance
    destroyer = TerraformDestroyer(
        config_file=args.config,
        workspace=args.workspace,
        auto_approve=args.auto_approve,
        target=args.targets,
    )

    # Execute destruction
    try:
        success = destroyer.destroy()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        logger.warning("\nDestruction interrupted by user")
        sys.exit(130)
    except Exception as e:
        logger.exception(f"Unexpected error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
