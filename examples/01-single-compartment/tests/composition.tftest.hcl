mock_provider "oci" {
  alias = "homeregion"
  mock_resource "oci_identity_compartment" {
    defaults = { id = "ocid1.compartment.oc1..synthetic", state = "ACTIVE" }
  }
}
run "provider_and_module_composition" {
  command = plan
  variables {
    tenancy_ocid          = "ocid1.tenancy.oc1..synthetic"
    user_ocid             = "ocid1.user.oc1..synthetic"
    fingerprint           = "synthetic"
    private_key_path      = "/nonexistent-synthetic-key.pem"
    home_region           = "eu-frankfurt-1"
    parent_compartment_id = "ocid1.compartment.oc1..parent"
  }
  assert {
    condition     = module.compartment.compartment_id == "ocid1.compartment.oc1..synthetic" && module.compartment.parent_compartment_id == "ocid1.compartment.oc1..parent"
    error_message = "Example provider/module composition must preserve the intended parent and resource outputs."
  }
}
