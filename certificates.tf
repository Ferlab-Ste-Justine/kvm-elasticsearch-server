resource "tls_private_key" "key" {
  count = var.tls_enabled ? 1 : 0
  algorithm   = "RSA"
  rsa_bits = var.server_certificate.key_length
}

resource "tls_cert_request" "request" {
  count = var.tls_enabled ? 1 : 0
  key_algorithm   = tls_private_key.key.0.algorithm
  private_key_pem = tls_private_key.key.0.private_key_pem

  subject {
    common_name  = "masters"
    organization = var.server_certificate.organization
  }

  ip_addresses = concat(
    ["127.0.0.1"],
    length(var.macvtap_interfaces) == 0 ? [var.ip] : [for macvtap_interface in var.macvtap_interfaces: macvtap_interface.ip]
  )
  dns_names = [
    var.name,
    var.is_master ? "masters.${var.domain}" : "workers.${var.domain}"
  ]
}

resource "tls_locally_signed_cert" "certificate" {
  count = var.tls_enabled ? 1 : 0
  cert_request_pem   = tls_cert_request.request.0.cert_request_pem
  ca_key_algorithm   = var.ca.key_algorithm
  ca_private_key_pem = var.ca.key
  ca_cert_pem        = var.ca.certificate

  validity_period_hours = var.server_certificate.validity_period
  early_renewal_hours = var.server_certificate.early_renewal_period

  allowed_uses = [
    "server_auth",
    "client_auth",
  ]

  is_ca_certificate = false
}