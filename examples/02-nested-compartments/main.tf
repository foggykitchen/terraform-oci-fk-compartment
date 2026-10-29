module "parent" {
  source    = "../.."
  providers = { oci = oci.homeregion }

  parent_compartment_id = var.parent_compartment_id
  name                  = "FoggyKitchenTraining"
  description           = "Parent compartment for training environments"
  enable_delete         = var.enable_delete
}

module "children" {
  source    = "../.."
  providers = { oci = oci.homeregion }
  for_each  = toset(["application", "data"])

  parent_compartment_id = module.parent.compartment_id
  name                  = "FoggyKitchen-${each.key}"
  description           = "Training ${each.key} compartment"
  enable_delete         = var.enable_delete
  freeform_tags         = { environment = "training", role = each.key }
}
