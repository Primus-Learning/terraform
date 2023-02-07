resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-security-group" {
  source = "./modules/security_group"
  env_prefix = var.env_prefix
  my_ip = var.my_ip
  vpc_id = aws_vpc.myapp-vpc.id
}

module "myapp-server-1" {
  source = "./modules/webserver"
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  instance_type = var.instance_type_1
  public_key_location = var.public_key_location
  vpc_id = aws_vpc.myapp-vpc.id
  subnet_id = module.myapp-subnet.subnet.id
  default_security_group_id = module.myapp-security-group.security_group.id
  key_name = var.key_name_1
}

module "myapp-server-2" {
  source = "./modules/webserver"
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  instance_type = var.instance_type_2
  public_key_location = var.public_key_location
  vpc_id = aws_vpc.myapp-vpc.id
  subnet_id = module.myapp-subnet.subnet.id
  default_security_group_id = module.myapp-security-group.security_group.id
  key_name = var.key_name_2
}