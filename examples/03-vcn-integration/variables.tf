variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "home_region" {
  description = "The home region of your OCI tenancy, not necessarily the workload region."
  type        = string
}

variable "parent_compartment_id" {
  description = "Existing parent compartment or tenancy OCID."
  type        = string
}

variable "enable_delete" {
  description = "Opt in to OCI compartment deletion and reject implicit adoption; see the module README."
  type        = bool
  default     = false
}

variable "region" {
  description = "Workload region for the VCN; can differ from home_region."
  type        = string
}
