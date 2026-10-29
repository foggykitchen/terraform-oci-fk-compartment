module "compartment" {
  source    = "../.."
  providers = { oci = oci.homeregion }

  parent_compartment_id = var.parent_compartment_id
  name                  = "FoggyKitchenCompartment"
  description           = "FoggyKitchen course compartment"
  enable_delete         = var.enable_delete
  freeform_tags         = { project = "foggykitchen" }
}
