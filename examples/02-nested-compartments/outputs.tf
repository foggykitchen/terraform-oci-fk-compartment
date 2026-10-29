output "parent_compartment_id" {
  value = module.parent.compartment_id
}

output "child_compartment_ids" {
  value = { for key, child in module.children : key => child.compartment_id }
}
