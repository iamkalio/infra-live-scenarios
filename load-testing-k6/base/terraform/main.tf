provider "aws" {
  region = var.region
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "base-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags                    = { Name = "base-public-subnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "base-igw" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "base-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}


data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "base-web" {
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Bootstrap Node.js via user_data script
  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user_data.log 2>&1
    set -ex

    yum update -y

    # Install Node.js (LTS) and Git
    curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
    yum install -y nodejs git

    # Create app directory
    mkdir -p /home/ec2-user/app

    # app.js file
    cat << 'EOT' > /home/ec2-user/app/app.js
    const http = require('http');

    const server = http.createServer((req, res) => {
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end('Application is Active!');
    });

    server.listen(3000, '0.0.0.0', () => {
      console.log('Server running on http://0.0.0.0:3000');
    });

    server.on('error', (error) => {
      console.error('Server error:', error);
    });
    EOT

    # Set permissions
    chown -R ec2-user:ec2-user /home/ec2-user/app
    chmod +x /home/ec2-user/app/app.js

    # Start app with log
    cd /home/ec2-user/app
    sleep 2
    nohup node app.js > app.log 2>&1 &

    # Output diagnostics
    echo "Network interfaces:" >> /home/ec2-user/debug.log
    ip addr show >> /home/ec2-user/debug.log
    echo "Listening ports:" >> /home/ec2-user/debug.log
    netstat -tuln >> /home/ec2-user/debug.log
  EOF

  tags = { Name = "base-web-server" }
}

