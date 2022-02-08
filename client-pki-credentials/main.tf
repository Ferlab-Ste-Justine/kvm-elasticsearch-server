resource "tls_private_key" "key" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

resource "tls_cert_request" "request" {
  key_algorithm   = tls_private_key.key.algorithm
  private_key_pem = tls_private_key.key.private_key_pem
  subject {
    common_name  = var.username
    organization = var.organization
  }
}

resource "tls_locally_signed_cert" "certificate" {
  cert_request_pem   = tls_cert_request.request.cert_request_pem
  ca_key_algorithm   = var.ca.key_algorithm
  ca_private_key_pem = var.ca.key
  ca_cert_pem        = var.ca.certificate

  validity_period_hours = var.validity_period
  early_renewal_hours = var.early_renewal_period

  allowed_uses = [
    "client_auth"
  ]

  is_ca_certificate = false
}