module "compartment" {
  source    = "../.."
  providers = { oci = oci.homeregion }

  parent_compartment_id = var.parent_compartment_id
  name                  = "FoggyKitchenNetworkLab"
  description           = "Compartment for the VCN integration example"
  enable_delete         = var.enable_delete
}

module "vcn" {
  source    = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git?ref=v0.2.0"
  providers = { oci = oci.workload }

  compartment_ocid = module.compartment.compartment_id
  name             = "FoggyKitchenVCN"
  vcn_cidr_blocks  = ["10.20.0.0/16"]
  dns_label        = "fkcompvcn"

  subnets = {
    private = {
      cidr_block = "10.20.1.0/24"
      dns_label  = "private"
    }
  }
}
