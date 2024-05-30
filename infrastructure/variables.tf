variable "docker_io_username" {
  description = "username for docker.io account"
  type        = string
  sensitive   = true
}

variable "docker_io_access_token" {
  description = "access token for docker.io account"
  type        = string
  sensitive   = true
}

variable "name_of_container_image" {
  description = "name of container image"
  type        = string
}

variable "tag_for_container_image" {
  description = "tag for container image"
  type        = string
}
