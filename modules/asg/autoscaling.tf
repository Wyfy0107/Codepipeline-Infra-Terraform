resource "aws_launch_configuration" "demo" {
  name_prefix          = "${var.project}-${var.environment}"
  image_id             = data.aws_ami.ubuntu-18_04.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2.name

  key_name                    = aws_key_pair.demo.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/../../scripts/codedeploy-agent.sh")

  security_groups = [
    aws_security_group.instance.id
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  name_prefix      = "${var.project}-${var.environment}"
  max_size         = 3
  min_size         = 1
  default_cooldown = 60

  vpc_zone_identifier  = var.vpc_subnets_id
  launch_configuration = aws_launch_configuration.demo.name
  health_check_type    = "ELB"
  termination_policies = ["OldestInstance", "OldestLaunchConfiguration"]
  target_group_arns = [
    aws_lb_target_group.demo.arn
  ]

  tag {
    key                 = "Name"
    value               = "${var.project}-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_policy" "cpu-high" {
  count                  = 1
  name                   = "${var.project}-${var.environment}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.demo.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  scaling_adjustment     = 1
}

resource "aws_autoscaling_policy" "cpu-low" {
  count                  = 1
  name                   = "${var.project}-${var.environment}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.demo.name
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  scaling_adjustment     = -1
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
