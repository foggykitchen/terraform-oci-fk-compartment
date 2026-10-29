mock_provider "oci" {
  alias = "homeregion"
  mock_resource "oci_identity_compartment" {
    defaults = { id = "ocid1.compartment.oc1..synthetic", state = "ACTIVE" }
  }
}
mock_provider "oci" {
  alias = "workload"
  mock_resource "oci_core_vcn" {
    defaults = { id = "ocid1.vcn.oc1..synthetic" }
  }
}
run "provider_and_module_composition" {
  command = plan
  variables {
    tenancy_ocid          = "ocid1.tenancy.oc1..synthetic"
    user_ocid             = "ocid1.user.oc1..synthetic"
    fingerprint           = "synthetic"
    private_key_path      = "/nonexistent-synthetic-key.pem"
    region                = "eu-amsterdam-1"
    home_region           = "eu-frankfurt-1"
    parent_compartment_id = "ocid1.compartment.oc1..parent"
  }
  assert {
    condition     = module.compartment.compartment_id == "ocid1.compartment.oc1..synthetic" && module.vcn.vcn_id == "ocid1.vcn.oc1..synthetic" && length(module.vcn.subnet_ids) == 1
    error_message = "Example provider/module composition must preserve the intended parent and resource outputs."
  }
}
