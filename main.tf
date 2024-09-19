resource "aws_cloudwatch_metric_alarm" "dead_letter_queue_alarm" {
  alarm_name          = "${var.queue_name}-messages-visible-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  unit                = "Count"
  period              = 60
  threshold           = var.threshold
  treat_missing_data  = "notBreaching"
  alarm_description   = "${upper(var.environment)}: ${var.queue_name} SQS message(s) visible"
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

data "aws_ssm_parameter" "personnel_slack_hook_url" {
  name      = "/config/slack/personell-slack-hook-url"
}

resource "aws_sns_topic" "sns_alarm_topic" {
  name = "${var.name_prefix}-${var.queue_name}-messages-visible-alarms"
}

module "alarms_to_slack" {
  source      = "github.com/nsbno/terraform-aws-alarms-to-slack?ref=3b8197b"
  name_prefix = var.name_prefix
  slack_webhook_urls = [
    data.aws_ssm_parameter.personnel_slack_hook_url.value,
  ]
  sns_topic_arns = [
    aws_sns_topic.sns_alarm_topic.arn
  ]
}