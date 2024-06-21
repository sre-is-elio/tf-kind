resource "tls_private_key" "this" {
  algorithm = var.tls.rsa.algorithm
  rsa_bits  = var.tls.rsa.rsa_bits
}
