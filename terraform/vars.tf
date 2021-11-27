variable "NAME" {
  default = "cassandra-cluster"
}

variable "ENVIRONMENT" {
  default = "production"
}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "VPC_ID" {
  default = "vpc-d630b2ab"
}

variable "SUBNET_IDs" {
  type = list(string)
  default = ["subnet-cff6f782", "subnet-cff6f782"]
}

variable "AMI" {
  default = "ami-07ebfd5b3428b6f4d"
}

variable "INSTANCE_TYPE" {
  default = "t2.small"
}

variable "CONFIG_BUCKET_NAME" {
}

variable "CONFIG_BUCKET_KEY" {
}