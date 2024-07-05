variable "private_subnet_1" {}
variable "private_subnet_2" {}
variable "security_group_id" {}

resource "aws_db_parameter_group" "custom_postgres12" {
  name        = "custom-postgres12"
  family      = "postgres12"
  description = "Custom parameter group for PostgreSQL 12"
}

resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "11.22"
  instance_class       = "db.t3.medium"
  identifier           = "mydb"
  username             = "foobar1234"
  password             = "foobar12345"
  parameter_group_name = aws_db_parameter_group.custom_postgres12.name
  multi_az             = true
  publicly_accessible  = false
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [var.private_subnet_1, var.private_subnet_2]
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

