resource "aws_cloudwatch_metric_alarm" "scaling-up" {
  count               = 1
  alarm_name          = "${var.project}-${var.environment}-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"

  evaluation_periods = 1
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 80

  alarm_actions = [
    aws_autoscaling_policy.cpu-high[0].arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scaling-down" {
  count               = 1
  alarm_name          = "${var.project}-${var.environment}-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"

  evaluation_periods = 1
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 50

  alarm_actions = [
    aws_autoscaling_policy.cpu-low[0].arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
}
