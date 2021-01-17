resource "aws_codedeploy_app" "demo" {
  compute_platform = "Server"
  name             = "demo"
}

resource "aws_iam_role" "codedeploy" {
  name = "codedeploy-demo"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "demo" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy.name
}

resource "aws_codedeploy_deployment_group" "demo" {
  app_name              = aws_codedeploy_app.demo.name
  deployment_group_name = "demo"
  service_role_arn      = aws_iam_role.codedeploy.arn

  ec2_tag_filter {
    type  = "KEY_AND_VALUE"
    key   = "Name"
    value = "demo"
  }
}
