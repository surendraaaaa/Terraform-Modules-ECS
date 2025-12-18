output "db_endpoint" { 
    value = aws_db_instance.mysql.address
     }
output "db_user_secret_arn" { 
    value = aws_secretsmanager_secret.db_user.arn
     }
output "db_password_secret_arn" { 
    value = aws_secretsmanager_secret.db_password.arn
     }
