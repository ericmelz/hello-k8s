variable "db_password" {
  description = "The password for the RDS MySQL database"
  type        = string
  default     = "hellopass"
}

variable "db_username" {
  description = "The username for the RDS MySQL database"
  type        = string
  default     = "hellouser"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "hello"
}
