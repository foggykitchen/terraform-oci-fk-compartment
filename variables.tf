variable "parent_compartment_id" {
  description = "OCID of the parent compartment or tenancy (root compartment)."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^ocid1\\.(tenancy|compartment)\\.", var.parent_compartment_id))
    error_message = "parent_compartment_id must be a tenancy or compartment OCID."
  }
}

variable "name" {
  description = "Compartment name. Use a unique name within the parent compartment."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.name)) > 0 && var.name == trimspace(var.name)
    error_message = "name must not be empty or have leading/trailing whitespace."
  }
}

variable "description" {
  description = "Compartment description. An empty string is allowed by OCI."
  type        = string
  nullable    = false
}

variable "enable_delete" {
  description = "OCI provider deletion/adoption behavior. False retains the compartment on destroy and permits implicit adoption on a name collision; true attempts deletion and rejects name collisions. This is not prevent_destroy."
  type        = bool
  default     = false
  nullable    = false
}

variable "defined_tags" {
  description = "Defined tags applied to the compartment; required tag namespaces must already exist."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "freeform_tags" {
  description = "Free-form tags applied to the compartment."
  type        = map(string)
  default     = {}
  nullable    = false
}
