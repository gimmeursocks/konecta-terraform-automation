# Root project setup
project_id      = ""
organization_id = ""
billing_account = ""
region          = ""

# labels        = {}
# apis          = []
# create_service_account = false
# service_account_roles  = []

# VPC
vpc_name    = ""
subnet_name = ""
cidr        = ""

# GCS
bucket_name = ""
location    = ""
# storage_class   = "STANDARD"
# force_destroy   = false
# versioning      = false
# uniform_access  = true

# Compute
instance_name = ""
machine_type  = ""
zone          = ""
image         = ""
network       = ""
subnetwork    = ""
# disk_size_gb = 20
# tags         = []

# Cloud SQL
sql_instance_name = ""
database_version  = ""
sql_machine_type  = ""
db_name           = ""
db_user           = ""
db_password       = "" # sensitive
# deletion_protection = true

# Cloud Run
cloudrun_name  = ""
cloudrun_image = ""
# cloudrun_env_vars             = {}
# cloudrun_allow_unauthenticated = false

# GKE
gke_cluster_name = ""
# gke_node_count  = 1
# gke_machine_type = "e2-medium"

# Load Balancer
lb_name = ""

# Pub/Sub
topic_name        = ""
subscription_name = ""
# pubsub_labels    = {}

# Monitoring
alert_name_prefix      = ""
monitoring_logs_bucket = ""
# alert_cpu_threshold     = 80
# alert_notification_channels = []
