variable "instance_type" {
  type = string
  default = "t3.micro"
  description = "description"
}

variable "project" {
  default = "expense"
}

variable "component" {
  default = "backend"
}

variable "environment" {
  default = "dev"
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}                                                                                                                       
