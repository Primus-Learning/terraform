module "redis" {
  source = "umotif-public/elasticache-redis/aws"
  version = "~> 3.0.0"

  name_prefix = "terraform-elasticache"
  num_cache_clusters = 1
  node_type = var.node_type
  engine_version = "6.x"
  port = 6379
  maintenance_window = "mon:03:00-mon:04:00"
  snapshot_window          = "04:00-06:00"
  snapshot_retention_limit = 7

  automatic_failover_enabled = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  apply_immediately = true
  family            = "redis6.x"
  description       = "Creating elasticahe redis using terraform"

  subnet_ids = var.subnet_ids
  vpc_id = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Project = "Terraform"
  }
}