terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "= 0.6.11"
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 3.4.0"
    }
  }
  required_version = ">= 1.0.0"
}