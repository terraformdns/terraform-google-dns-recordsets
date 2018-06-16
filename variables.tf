
variable "managed_zone_name" {
  type        = string
  description = "The name of the Google Cloud DNS managed zone to add records to."
}

variable "project_id" {
  type        = string
  default     = ""
  description = "The id of the Google API project that the given managed zone belongs to. If not set, the project id selected in the provider configuration is used instead."
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS record objects to manage, in the standard terraformdns structure."
}
