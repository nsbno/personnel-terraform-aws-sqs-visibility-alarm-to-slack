variable "alarm_name" {
  description = "The name of the alarm"
  type        = string
}

variable "queue_name" {
  description = "Name of SQS queue to monitor"
  type        = string
}

variable "threshold" {
  description = "Number of messages that should trigger an alarm"
  type        = number
}