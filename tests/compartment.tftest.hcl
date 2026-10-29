mock_provider "oci" {
  mock_resource "oci_identity_compartment" {
    defaults = {
      id    = "ocid1.compartment.oc1..synthetic"
      state = "ACTIVE"
    }
  }
}

variables {
  parent_compartment_id = "ocid1.compartment.oc1..parent"
  name                  = "FoggyKitchenCompartment"
  description           = "Training compartment"
}

run "default_contract" {
  command = plan
  assert {
    condition     = !oci_identity_compartment.this.enable_delete
    error_message = "Deletion/adoption behavior must default to enable_delete=false."
  }
  assert {
    condition     = oci_identity_compartment.this.compartment_id == "ocid1.compartment.oc1..parent" && oci_identity_compartment.this.name == "FoggyKitchenCompartment" && oci_identity_compartment.this.description == "Training compartment"
    error_message = "Parent, name and description must reach the OCI resource unchanged."
  }
  assert {
    condition     = output.compartment_id == "ocid1.compartment.oc1..synthetic" && output.parent_compartment_id == "ocid1.compartment.oc1..parent" && output.name == "FoggyKitchenCompartment" && output.description == "Training compartment" && output.state == "ACTIVE"
    error_message = "Outputs must distinguish the new compartment OCID from the parent OCID."
  }
}

run "explicit_deletion_opt_in" {
  command = plan
  variables {
    enable_delete = true
  }
  assert {
    condition     = oci_identity_compartment.this.enable_delete
    error_message = "Explicit enable_delete=true must be passed through to OCI."
  }
}

run "tags_are_preserved" {
  command = plan
  variables {
    defined_tags  = { "Operations.Owner" = "platform" }
    freeform_tags = { project = "foggykitchen", environment = "training" }
  }
  assert {
    condition     = oci_identity_compartment.this.defined_tags == tomap({ "Operations.Owner" = "platform" }) && oci_identity_compartment.this.freeform_tags == tomap({ project = "foggykitchen", environment = "training" })
    error_message = "Both tag maps must be preserved without adding implicit tags."
  }
}

run "tenancy_as_parent" {
  command = plan
  variables {
    parent_compartment_id = "ocid1.tenancy.oc1..synthetic"
  }
  assert {
    condition     = output.parent_compartment_id == "ocid1.tenancy.oc1..synthetic"
    error_message = "Tenancy OCIDs must be accepted as root compartment parents."
  }
}

run "empty_description_is_valid" {
  command = plan
  variables {
    description = ""
  }
  assert {
    condition     = oci_identity_compartment.this.description == ""
    error_message = "The module must allow the empty description accepted by OCI."
  }
}

run "null_optional_inputs_use_defaults" {
  command = plan
  variables {
    enable_delete = null
    defined_tags  = null
    freeform_tags = null
  }
  assert {
    condition     = !oci_identity_compartment.this.enable_delete && length(oci_identity_compartment.this.defined_tags) == 0 && length(oci_identity_compartment.this.freeform_tags) == 0
    error_message = "Null optional inputs must resolve to the documented defaults."
  }
}

run "reject_wrong_parent_ocid_type" {
  command = plan
  variables {
    parent_compartment_id = "ocid1.vcn.oc1..synthetic"
  }
  expect_failures = [var.parent_compartment_id]
}

run "reject_empty_parent" {
  command = plan
  variables {
    parent_compartment_id = ""
  }
  expect_failures = [var.parent_compartment_id]
}

run "reject_blank_name" {
  command = plan
  variables {
    name = "  "
  }
  expect_failures = [var.name]
}

run "reject_padded_name" {
  command = plan
  variables {
    name = " FoggyKitchenCompartment "
  }
  expect_failures = [var.name]
}
