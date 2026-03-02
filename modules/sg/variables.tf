variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR du VPC, utilisé pour restreindre l'egress de B et C"
}