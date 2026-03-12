variable "region"{
    default = "us-east-1"
}
variable "instance_type"{
    default = "t2.micro"
}
variable "key_name"{
    description = "SSH key pair name"
}
variable "allowed_ip"{
    description = "your IP for SSH"
}