module "vpc" {
  source = "./../../modules/vpc"
}

# EC2 Instance
resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  # user_data = file("${path.module}/app1-install.sh")
  key_name = var.instance_keypair
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id   ]
  tags = {
    "Name" = "EC2 Demo 2"
  }

#Set hostname using provisioner
provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname cloudEc2.example.com",
      "sudo yum install -y docker",
      "sudo sleep 20s",
      "sudo systemctl enable docker.service",
      "sudo systemctl enable containerd.service",
      "sudo sleep 5s",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart docker.service",
      "sudo sleep 5s",
      "sudo docker container run --name my-nginx-1 -p80:80 -d nginx",
      "sleep 10s"
      ]
    connection {
        host = aws_instance.myec2vm.public_dns
        type = "ssh"
        user = "ec2-user"
        private_key = "${file("/root/key/terraform-key.pem")}"
        timeout = "1m"
        agent = false
    }
}

}

# Create Security Group - SSH Traffic
resource "aws_security_group" "vpc-ssh" {
  name        = "vpc-ssh"
  description = "Dev VPC SSH"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"    
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-ssh"
  }
}

# Create Security Group - Web Traffic
resource "aws_security_group" "vpc-web" {
  name        = "vpc-web"
  description = "Dev VPC Web"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  egress {
    description = "Allow all ip and ports outbound"    
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-web"
  }
}

