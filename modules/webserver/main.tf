data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh-key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.default_security_group_id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("entry-script.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}