resource "random_password" "db_password" {
  length  = 20
  special = true
}

# Secrets: separate username and password
resource "aws_secretsmanager_secret" "db_user" {
  name = "${var.name_prefix}/db/user"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_user_val" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = "root"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.name_prefix}/db/password"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_password_val" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       =  { 
    Name = "${var.name_prefix}-db-subnet-group"
    }
}

resource "aws_db_instance" "mysql" {
  identifier                 = "${var.name_prefix}-mysql"
  engine                     = "mysql"
  engine_version             = var.db_engine_version
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  db_name                    = var.db_name
  username                   = "root"
  password                   = random_password.db_password.result
  multi_az                   = var.db_multi_az
  deletion_protection        = var.db_deletion_protection
  backup_retention_period    = var.db_backup_retention
  storage_encrypted          = true
  publicly_accessible        = false
  vpc_security_group_ids     = [var.rds_sg_id]
  db_subnet_group_name       = aws_db_subnet_group.this.name
  auto_minor_version_upgrade = true
  apply_immediately          = false
  tags                       =  { 
    Name = "${var.name_prefix}-mysql"
     }
}
