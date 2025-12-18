project_name = "notes-app"
region       = "us-east-2"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

enable_public_frontend = true

frontend_container_port = 80
backend_container_port  = 5000

frontend_image = "surendraprajapati/notes-app-backend:latest"
backend_image  = "surendraprajapati/notes-app-frontend:latest"

frontend_health_check_path = "/"
backend_health_check_path  = "/health"

ecs_instance_type    = "m7i-flex.large"
ecs_desired_capacity = 2
ecs_min_size         = 1
ecs_max_size         = 3

key_pair_name  = "MyAWSKP"
allow_ssh_cidr = "0.0.0.0/0"

db_instance_class      = "db.m7i-flex.large"
db_allocated_storage   = 25
db_engine_version      = "8.0.35"
db_name                = "notes_db"
db_multi_az            = false
db_deletion_protection = false
db_backup_retention    = 7

container_cpu    = 256
container_memory = 512

log_retention_days = 14
