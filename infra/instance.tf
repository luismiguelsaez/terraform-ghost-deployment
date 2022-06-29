
resource "aws_security_group" "public" {
  name        = "public"
  description = "Allow public inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Ghost from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Env = var.environment
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "main" {
  key_name   = "main"
  public_key = chomp(tls_private_key.ssh.public_key_openssh)
}

resource "aws_instance" "ghost" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_size

  associate_public_ip_address = true
  availability_zone = var.instance_az
  security_groups = [aws_security_group.public.id]

  subnet_id = aws_subnet.main.id

  key_name = aws_key_pair.main.key_name

  user_data = <<EOF
${file("bootstrap.sh")}

export PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cat <<EON > /home/app/docker-compose.yml
${file("docker-compose.yml")}
EON

chown app. /home/app/docker-compose.yml
docker compose -f /home/app/docker-compose.yml up -d
EOF

  tags = {
    Env = var.environment
    Name = "Ghost"
  }
}
