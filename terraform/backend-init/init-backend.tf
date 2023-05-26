variable "compartment_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_namespace" {
  type = string
}

variable "state_folder" {
  type = string
}

resource "oci_objectstorage_bucket" "state_bucket" {
  compartment_id = var.compartment_id
  name           = var.bucket_name
  namespace      = var.bucket_namespace
}

resource "oci_objectstorage_object" "state_object" {
  bucket = oci_objectstorage_bucket.state_bucket.name
  # content   = "TO BE WRITTEN BY TERRAFORM"
  namespace = var.bucket_namespace
  object    = "${var.state_folder}/terraform.tfstate"
}

output "state_bucket_name" {
  value = oci_objectstorage_bucket.state_bucket.name
}

output "state_bucket_id" {
  value = oci_objectstorage_bucket.state_bucket.id
}

output "state_bucket_ocid" {
  value = oci_objectstorage_bucket.state_bucket.bucket_id
}

output "state_bucket_uri" {
  value = "https://objectstorage.us-sanjose-1.oraclecloud.com/n/${oci_objectstorage_bucket.state_bucket.namespace}/b/${oci_objectstorage_bucket.state_bucket.name}"
}

/*
# helpful commands

terraform state show oci_objectstorage_bucket.state_bucket
*/
