
variable "access_key" {
  description = "This is the access key to the AWS services"
  type        = string 
  default     = "*******"
}


variable "secret_key" {
  description = "This is the secret key  to the AWS services"
  type        = string
  default     = "*********"
}

variable "instance_type" {
  description = "This is the type (size) of AWS EC2 we will be deploying"
  type        = string
  default     = "t2.micro" 
}

variable "ami" {
  description = "This is the type of AWS EC2 operating system and version we will be deploying"
  type        = string
  default     = "ami-******"
}

variable "region" {
  description = "This is the region of our deployments"
  type        = string
  default     = "eu-west-3" # For Paris
}

variable "availability_zone" {
  description = "This is the availability zone of the resource"
  type        = string
  default     = "eu-west-3a" # For Paris
}

variable "mlops_vpc_cidr" {
  description = "This is the CIDR Block of my MLOps Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "mlops_subnet_cidr" {
  description = "This is the 1st subnet of my MLOPs deployment"
  type        = string
  default     = "10.0.1.0/24"
}

variable "my_public_ip" {
  description = "This is the public IP of my home network"
  type        = string
  default     = "xx.xxx.xxx.xx/32" 

}

