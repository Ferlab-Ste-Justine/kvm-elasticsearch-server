locals {
  cloud_init_volume_name = var.cloud_init_volume_name == "" ? "${var.name}-cloud-init.iso" : var.cloud_init_volume_name
  network_config = templatefile(
    "${path.module}/files/network_config.yaml.tpl", 
    {
      macvtap_interfaces = var.macvtap_interfaces
    }
  )
  network_interfaces = length(var.macvtap_interfaces) == 0 ? [{
    network_id = var.network_id
    macvtap = null
    addresses = [var.ip]
    mac = var.mac != "" ? var.mac : null
    hostname = var.name
  }] : [for macvtap_interface in var.macvtap_interfaces: {
    network_id = null
    macvtap = macvtap_interface.interface
    addresses = null
    mac = macvtap_interface.mac
    hostname = null
  }]
}

data "template_cloudinit_config" "user_data" {
  gzip = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/files/user_data.yaml.tpl", 
      {
        nameserver_ips = var.nameserver_ips
        domain = var.domain
        is_master = var.is_master
        initial_masters = var.initial_masters
        node_name = var.name
        cluster_name = var.cluster_name
        s3_endpoint = var.s3_endpoint
        s3_protocol = var.s3_protocol
        s3_access_key = var.s3_access_key
        s3_secret_key = var.s3_secret_key
        server_key = tls_private_key.key.private_key_pem
        server_certificate = tls_locally_signed_cert.certificate.cert_pem
        ca_certificate = var.ca.certificate
        pki_auth = var.pki_auth
        ssh_admin_user = var.ssh_admin_user
        admin_user_password = var.admin_user_password
        ssh_admin_public_key = var.ssh_admin_public_key
      }
    )
  }
}

resource "libvirt_cloudinit_disk" "elasticsearch" {
  name           = local.cloud_init_volume_name
  user_data      = data.template_cloudinit_config.user_data.rendered
  network_config = length(var.macvtap_interfaces) > 0 ? local.network_config : null
  pool           = var.cloud_init_volume_pool
}

resource "libvirt_domain" "elasticsearch" {
  name = var.name

  cpu {
    mode = "host-passthrough"
  }

  vcpu = var.vcpus
  memory = var.memory

  disk {
    volume_id = var.volume_id
  }

  dynamic "network_interface" {
    for_each = local.network_interfaces
    content {
      network_id = network_interface.value["network_id"]
      macvtap = network_interface.value["macvtap"]
      addresses = network_interface.value["addresses"]
      mac = network_interface.value["mac"]
      hostname = network_interface.value["hostname"]
    }
  }

  autostart = true

  cloudinit = libvirt_cloudinit_disk.elasticsearch.id

  //https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.13/ubuntu/ubuntu-example.tf#L61
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}