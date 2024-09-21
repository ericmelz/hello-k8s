variable "domains" {
  type    = list(string)
  default = ["emelz-test-1.site", "emelz-test-2.site"]
}

variable "load_balancer_arn" {
  description = "ARN of the existing load balancer"
  type        = string
  default     = "arn:aws:elasticloadbalancing:us-west-2:638173936794:loadbalancer/net/aeb51f9f871cd47cab511a5dda474b72/4296c544cdc993ea"
}

variable "target_group_arn" {
  description = "ARN of the target group for the load balancer"
  type        = string
  default     = "arn:aws:elasticloadbalancing:us-west-2:638173936794:targetgroup/k8s-default-hellok8s-0e9bdb4a04/ed00270e6feb0e1d"
}
