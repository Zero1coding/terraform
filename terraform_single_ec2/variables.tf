variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}
