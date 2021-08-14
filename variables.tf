variable "region" {
  description = "Region where the ASG to be provisioned"
  type = string
  default = "us-east-1"
    
}
variable "lb_subnet" {
    description = "The Subnets to be added for the LB"
    type = list(string)
}

variable "lb_SG" {
    description = "The Subnets to be added for the LB"
    type = list(string)
}

variable "name" {
    description = " Name"
    type = string
}

variable "tg_vpc_id" {
    description = "vpc id for the target group"
    type        = string
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

variable "listener_port" {
    type = number
    
}

variable "listener_porotocol" {
    type = string
}

variable "ssl_policy" {
    type = string
    default = null
}

variable "certificate_arn" {
    type = string
    default = null
}

variable "idle_timeout" {
    type = number
    default = 60
}
