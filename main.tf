resource "aws_rds_cluster" "postgresql" {
  cluster_identifier = "terraform-aurora-rds"
  engine = var.engine
  engine_version = var.engine_version
  database_name = var.db_name
  master_username = var.username
  master_password = var.password
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  apply_immediately = true
  skip_final_snapshot = true
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  count = 1
  identifier = "terraform-aurora-rds-demo-instance"
  cluster_identifier = aws_rds_cluster.postgresql.id
  instance_class = var.instance_class
  engine = aws_rds_cluster.postgresql.engine
  engine_version = aws_rds_cluster.postgresql.engine_version
  publicly_accessible = true
}