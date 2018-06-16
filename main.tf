
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    google = ">= 1.14.0"
  }
}

data "google_dns_managed_zone" "container" {
  project = var.project_id != "" ? var.project_id : null
  name    = var.managed_zone_name
}

resource "google_dns_record_set" "this" {
  count = length(var.recordsets)

  project      = var.project_id != "" ? var.project_id : null
  managed_zone = var.managed_zone_name

  name = (
    var.recordsets[count.index].name != "" ?
    "${var.recordsets[count.index].name}.${data.google_dns_managed_zone.container.dns_name}" :
    data.google_dns_managed_zone.container.dns_name
  )
  type = var.recordsets[count.index].type
  ttl  = var.recordsets[count.index].ttl

  rrdatas = var.recordsets[count.index].records
}
