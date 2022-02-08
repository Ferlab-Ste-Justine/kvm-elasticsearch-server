variable "name" {
  description = "Name of the vm"
  type = string
}

variable "cluster_name" {
  description = "Name of the es cluster"
  type = string
}

variable "vcpus" {
  description = "Number of vcpus to assign to the vm"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Amount of memory in MiB"
  type        = number
  default     = 8192
}

variable "volume_id" {
  description = "Id of the disk volume to attach to the vm"
  type        = string
}

variable "network_id" {
  description = "Id of the libvirt network to connect the vm to if you plan on connecting the vm to a libvirt network"
  type        = string
  default     = ""
}

variable "ip" {
  description = "Ip address of the vm if a libvirt network is selected"
  type        = string
  default     = ""
}

variable "mac" {
  description = "Mac address of the vm if a libvirt network is selected"
  type        = string
  default     = ""
}

variable "macvtap_interfaces" {
  description = "List of macvtap interfaces. Mutually exclusive with the network_id, ip and mac fields. Each entry has the following keys: interface, prefix_length, ip, mac, gateway and dns_servers"
  type        = list(any)
  default = []
}

variable "cloud_init_volume_pool" {
  description = "Name of the volume pool that will contain the cloud init volume"
  type        = string
}

variable "cloud_init_volume_name" {
  description = "Name of the cloud init volume"
  type        = string
  default = ""
}

variable "ssh_admin_user" { 
  description = "Pre-existing ssh admin user of the image"
  type        = string
  default     = "ubuntu"
}

variable "admin_user_password" { 
  description = "Optional password for admin user"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_admin_public_key" {
  description = "Public ssh part of the ssh key the admin will be able to login as"
  type        = string
}

variable "domain" {
  description = "Domain that should give the ips of the workers on the 'workers' subdomain and the ip of the masters on the 'masters' subdomain"
  type        = string
}

variable "nameserver_ips" {
  description = "Ips of explicit nameservers that will resolve the elasticsearch domain. Can be left empty if the implicit network servers already do this."
  type = list(string)
  default = []
}

variable "is_master" {
  description = "Whether or not the vm is a master"
  type        = bool
  default     = false
}

variable "initial_masters" {
  description = "List of host names for the initial masters to bootstrap the cluster. Should be empty when joining a pre-existing cluster"
  type        = list(string)
}

variable "s3_endpoint" {
  description = "Endpoint used to connect to an s3-compatible store for backups"
  type = string
  default = ""
}

variable "s3_protocol" {
  description = "Protocol to use (http or https) when connecting to the s3 store for backups"
  type = string
  default = "https"
}

variable "s3_access_key" {
  description = "Endpoint used to connect to an s3-compatible store for backups"
  type = string
  default = ""
  sensitive = true
}

variable "s3_secret_key" {
  description = "Protocol to use (http or https) when connecting to the s3 store for backups"
  type = string
  default = ""
  sensitive = true
}

variable "ca" {
  description = "The ca that will sign the es certificates. Should have the following keys: key, key_algorithm, certificate"
  type = any
}

variable "organization" {
  description = "The es servers certificates' organization"
  type = string
  default = "Ferlab"
}

variable "certificate_validity_period" {
  description = "The es servers cluster's certificates' validity period in hours"
  type = number
  default = 100*365*24
}

variable "certificate_early_renewal_period" {
  description = "The es servers cluster's certificates' early renewal period in hours"
  type = number
  default = 365*24
}

variable "key_length" {
  description = "The key length of the certificates' private key"
  type = number
  default = 4096
}

variable "pki_auth" {
  description = "Whether or not the pki auth is enabled"
  type        = bool
  default     = false
}