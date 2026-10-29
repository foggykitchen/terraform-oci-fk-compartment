output "compartment_id" {
  description = "OCID of the created or adopted compartment, not its parent."
  value       = oci_identity_compartment.this.id
}

output "parent_compartment_id" {
  description = "OCID of the parent compartment or tenancy."
  value       = oci_identity_compartment.this.compartment_id
}

output "name" {
  description = "Compartment name."
  value       = oci_identity_compartment.this.name
}

output "description" {
  description = "Compartment description."
  value       = oci_identity_compartment.this.description
}

output "state" {
  description = "Compartment lifecycle state reported by OCI."
  value       = oci_identity_compartment.this.state
}
