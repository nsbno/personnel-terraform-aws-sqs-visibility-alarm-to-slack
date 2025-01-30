resource "aws_cloudwatch_metric_alarm" "dead_letter_queue_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  unit                = "Count"
  period              = 60
  threshold           = var.threshold
  treat_missing_data  = "notBreaching"
  alarm_description   = "${var.queue_name} SQS message(s) visible"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.sns_alarm_topic.arn]
  ok_actions          = [aws_sns_topic.sns_alarm_topic.arn]
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  statistic           = "Sum"
  dimensions = {
    QueueName = var.queue_name
  }
}

data "aws_ssm_parameter" "slack_webhook_url" {
  name = "/config/slack/webhooks/alerts"
}

resource "aws_sns_topic" "sns_alarm_topic" {
  name = var.alarm_name
}

module "alarms_to_slack" {
  source      = "github.com/nsbno/terraform-aws-alarms-to-slack?ref=3b8197b"
  name_prefix = var.alarm_name
  slack_webhook_urls = [
    data.aws_ssm_parameter.slack_webhook_url.value,
  ]
  sns_topic_arns = [
    aws_sns_topic.sns_alarm_topic.arn
  ]
}