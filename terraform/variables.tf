variable "account" {
  description = "Choose your account."
}

variable "profile" {
  description = "Choose your profile."
}

variable "env" {
  default     = "prod"
  description = "Choose your env."
}

variable "project" {
  description = "Choose your project key."
}

variable "region" {
  default     = "us-east-1"
  description = "Main region."
}

variable "codestarconnections_connection_arn" {
  default     = "arn:aws:codeconnections:us-east-1:396608803901:connection/58bc7107-ca7d-4924-a9b5-dc659c4cf3b2"
  description = "arn connection"
}
