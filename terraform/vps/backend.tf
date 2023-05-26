terraform {
  backend "http" {
    # address = "http://... specified in backend.tfvars"
    update_method = "PUT"
  }
}
