# Google Cloud DNS Recordsets Module

This module manages DNS recordsets in a given Google Cloud Managed DNS zone. It
is part of [the `terraformdns` project](https://terraformdns.github.io/).

## Example Usage

```hcl
resource "google_dns_managed_zone" "example" {
  name     = "terraformdns-example"
  dns_name = "example.com."
}

module "dns_records" {
  source = "terraformdns/dns-recordsets/google"

  managed_zone_name = google_dns_managed_zone.example.name
  recordsets = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      records = [
        "192.0.2.56",
      ]
    },
    {
      name    = ""
      type    = "MX"
      ttl     = 3600
      records = [
        "1 mail1",
        "5 mail2",
        "5 mail3",
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 3600
      records = [
        "\"v=spf1 ip4:192.0.2.3 include:backoff.${google_dns_managed_zone.example.dns_name} -all\"",
      ]
    },
    {
      name    = "_sip._tcp"
      type    = "SRV"
      ttl     = 3600
      records = [
        "10 60 5060 sip1",
        "10 20 5060 sip2",
        "10 20 5060 sip3",
        "20  0 5060 sip4",
      ]
    },
  ]
}
```

## Compatibility

When using this module, always use a version constraint that constraints to at
least a single major version. Future major versions may have new or different
required arguments, and may use a different internal structure that could
cause recordsets to be removed and replaced by the next plan.

## Arguments

- `managed_zone_name` is the name of the manazed zone to add records to.
- `project_id` (optional) is the id of the Google API project to which the
  given managed zone belongs. If not set, the project from the provider
  configuration is used.
- `recordsets` is a list of DNS recordsets in the standard `terraformdns`
  recordset format.

This module requires the `google` provider.

Due to current limitations of the Terraform language, recordsets in Google
Cloud DNS are correlated to `recordsets` elements using the index into the
`recordsets` list. Adding or removing records from the list will therefore
cause this module to also update all records with indices greater than where
the addition or removal was made.
