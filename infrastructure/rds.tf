resource "aws_db_subnet_group" "default_vpc" {
  name       = "tf-rds-subnets"
  subnet_ids = data.aws_subnets.default_vpc_subnets.ids

  tags = { Name = "tf-rds-subnets" }
}

resource "aws_db_instance" "postgres" {
  identifier        = "tf-postgres-db"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  db_name           = "grocerydb"
  username          = "dbadmin"   # <-- change from admin
  password          = var.db_password
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.default_vpc.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  tags = {
    Name = "tf-postgres"
  }
}
