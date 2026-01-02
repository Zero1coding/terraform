resource "aws_security_group" "app_sg" {
  name        = "flask-express-sg"
  description = "Allow SSH, Flask, and Express"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Express"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "single_ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y python3 git

curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

cd /home/ec2-user
git clone https://github.com/zero1coding/flask-node-docker-kubernetes-AWS-app.git
cd flask-node-docker-kubernetes-AWS-app

# BACKEND
cd backend
pip3 install -r requirements.txt
nohup python3 app.py > backend.log 2>&1 &

# FRONTEND
cd ../frontend
npm install
nohup node server.js > frontend.log 2>&1 &
EOF
}