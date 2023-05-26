resource "oci_core_vcn" "sandbox_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_of_deployment}_vcn"
  dns_label      = "${var.name_of_deployment}vcn"
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_subnet" "sandbox_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = var.subnet_cidr_block
  display_name        = "${var.name_of_deployment}_subnet"
  dns_label           = "${var.name_of_deployment}subnet"
  security_list_ids   = [oci_core_vcn.sandbox_vcn.default_security_list_id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.sandbox_vcn.id
  route_table_id      = oci_core_vcn.sandbox_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.sandbox_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "sandbox_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_of_deployment} Internet Gateway"
  enabled        = "true"
  vcn_id         = oci_core_vcn.sandbox_vcn.id
}

resource "oci_core_network_security_group" "sandbox_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.sandbox_vcn.id
  display_name   = "${var.name_of_deployment} Security Group"
}

resource "oci_core_network_security_group_security_rule" "allow_http_from_all" {
  network_security_group_id = oci_core_network_security_group.sandbox_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTP from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_https_from_all" {
  network_security_group_id = oci_core_network_security_group.sandbox_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow HTTPS from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "allow_ssh_from_all" {
  network_security_group_id = oci_core_network_security_group.sandbox_nsg.id
  direction                 = "INGRESS"
  protocol                  = 6 # tcp

  description = "Allow SSH from all"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"
  stateless   = false

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}


resource "oci_core_default_route_table" "sandbox_default_route_table" {
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.sandbox_internet_gateway.id
  }
  manage_default_resource_id = oci_core_vcn.sandbox_vcn.default_route_table_id
}

resource "oci_core_instance" "instance_1" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.name_of_deployment}1"
  shape               = var.instance_shape

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.ocpus
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.sandbox_subnet.id
    display_name     = "${var.name_of_deployment}1_vnic"
    assign_public_ip = true
    hostname_label   = "${var.name_of_deployment}1"
    nsg_ids          = [oci_core_network_security_group.sandbox_nsg.id]
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  timeouts {
    create = "10m"
  }
}


resource "oci_core_instance" "instance_2" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.name_of_deployment}2"
  shape               = var.instance_shape

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.ocpus
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.sandbox_subnet.id
    display_name     = "${var.name_of_deployment}2_vnic"
    assign_public_ip = true
    hostname_label   = "${var.name_of_deployment}2"
    nsg_ids          = [oci_core_network_security_group.sandbox_nsg.id]
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  timeouts {
    create = "10m"
  }
}

output "machine_1_public_ip" {
  value = oci_core_instance.instance_1.public_ip
}

output "machine_2_public_ip" {
  value = oci_core_instance.instance_2.public_ip
}

output "machine_1_private_ip" {
  value = oci_core_instance.instance_1.private_ip
}

output "machine_2_private_ip" {
  value = oci_core_instance.instance_2.private_ip
}

# uncomment if you want to attach block storage to one of your sandbox instances
# resource "oci_core_volume" "sandbox_volume" {
#   compartment_id      = var.compartment_ocid
#   display_name        = "${var.name_of_deployment}_volume"
#   size_in_gbs         = var.volume_size_in_gbs
#   availability_domain = data.oci_identity_availability_domain.ad.name
# }

# resource "oci_core_volume_attachment" "sandbox_volume_attachment" {
#   attachment_type = "iscsi"
#   instance_id     = oci_core_instance.sandbox_instance.id
#   volume_id       = oci_core_volume.sandbox_volume.id
# }
