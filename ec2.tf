resource "aws_instance" "demo" {
  ami                  = "ami-00831fc7c1e3ddc60"
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.demo.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2.name

  security_groups = [
    aws_security_group.demo.name
  ]

  tags = {
    Name = "demo"
  }
}

resource "aws_key_pair" "demo" {
  key_name   = "demo"
  public_key = file("./ec2.key.pub")
}

resource "aws_security_group" "demo" {
  name = "demo"

  ingress {
    cidr_blocks = ["88.114.118.158/32"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${var.project}-${var.environment}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2" {
  name   = "${var.project}-${var.environment}"
  role   = aws_iam_role.ec2.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project}-${var.environment}"
  role = aws_iam_role.ec2.id
}

resource "null_resource" "demo" {
  connection {
    host        = aws_instance.demo.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ec2.key")
  }

  triggers = {
    codedeploy_agent_install = sha1(file("app/scripts/codedeploy-agent.sh"))
  }

  provisioner "remote-exec" {
    script = "app/scripts/codedeploy-agent.sh"
  }
}

output "server_ip" {
  description = "Server public ip"
  value       = aws_instance.demo.public_ip
}
