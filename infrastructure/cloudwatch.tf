resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/${var.ecr_repo_name}"
  retention_in_days = 14
}

# Create metric filter for lines containing ERROR => metric per minute
resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "${var.ecr_repo_name}-errors"
  log_group_name = aws_cloudwatch_log_group.app.name
  pattern        = "\"ERROR\""

  metric_transformation {
    name      = "${var.ecr_repo_name}_ErrorCount"
    namespace = "GroceryApp"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "app_errors_alarm" {
  alarm_name          = "${var.ecr_repo_name}-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  metric_name         = "${var.ecr_repo_name}_ErrorCount"
  namespace           = "GroceryApp"
  period              = 60
  statistic           = "Sum"
  alarm_description   = "Alert if app logs contain ERROR lines"
}

