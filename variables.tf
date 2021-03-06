variable "service_account_key" {
  type = "string"
  description = "Service account JSON file to access Google Cloud API"
}

variable "project" {
  type = "string"
  description = "Google Cloud project name"
}

variable "ssh_connection" {
  type = "string"
  description = "<USERNAME>:<SSH_PUBLIC_KEY>"
}