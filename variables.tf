variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "queue_name" {
  description = "sqs queue to monitor"
  type        = string
}

variable "threshold" {
  description = "number of messages that should trigger an alarm"
  type        = number
}