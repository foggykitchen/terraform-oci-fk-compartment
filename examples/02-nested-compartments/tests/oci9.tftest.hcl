# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_resource "oci_identity_compartment" {
    defaults = { "id" = "MOCK_OCID_COMPARTMENT", "inactive_state" = "mock-value", "is_accessible" = false, "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
mock_provider "oci" {
  alias = "homeregion"
  mock_resource "oci_identity_compartment" {
    defaults = { "id" = "MOCK_OCID_COMPARTMENT", "inactive_state" = "mock-value", "is_accessible" = false, "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
}
variables {
  tenancy_ocid          = "MOCK_OCID_TENANCY"
  user_ocid             = "MOCK_OCID_MOCK"
  fingerprint           = "compatibility"
  private_key_path      = "/unused-by-mock"
  home_region           = "eu-frankfurt-1"
  parent_compartment_id = "MOCK_OCID_COMPARTMENT"
}

run "oci9_plan" {
  command   = plan
  providers = { oci = oci, oci.homeregion = oci.homeregion }
}
