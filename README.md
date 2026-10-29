# terraform-oci-fk-compartment

Reusable **Terraform/OpenTofu module** for one OCI IAM compartment. It is part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/) and composes with the VCN, compute, database and other FoggyKitchen modules.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

## 🎯 Purpose

Provide a small compartment building block with an explicit parent, caller-controlled provider and predictable outputs. Reuse the module with `for_each` or nest module calls for a compartment hierarchy.

## ✨ What the module does

- Creates or adopts one `oci_identity_compartment` according to the OCI provider's `enable_delete` setting.
- Accepts a parent compartment or tenancy OCID, name, description and tags.
- Returns the new compartment OCID separately from the parent OCID.
- Inherits the OCI provider passed by the caller; it configures no authentication internally.

IAM policies, dynamic groups, quotas, tag namespaces, VCNs and workloads are outside this module. It adds no fixed sleep, provisioner or extra provider. IAM changes can take time to propagate; a successful compartment operation does not prove immediate workload availability in every region.

## 📂 Repository structure

```text
terraform-oci-fk-compartment/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── LICENSE
├── SUPPORT.md
├── README.md
├── examples/
│   ├── 01-single-compartment/
│   ├── 02-nested-compartments/
│   ├── 03-vcn-integration/
│   └── README.md
└── tests/
    ├── compartment.tftest.hcl
    └── README.md
```

## 🚀 Usage

Use Terraform/OpenTofu >= 1.6 and `oracle/oci ~> 6.0`. Configure authentication in the root configuration and pass its home-region provider:

```hcl
provider "oci" {
  alias            = "homeregion"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.home_region
}

module "compartment" {
  source    = "../terraform-oci-fk-compartment"
  providers = { oci = oci.homeregion }

  parent_compartment_id = var.parent_compartment_id
  name                  = "FoggyKitchenCompartment"
  description           = "FoggyKitchen course compartment"
  enable_delete         = false
  freeform_tags         = { project = "foggykitchen" }
}
```

The source above assumes a sibling local checkout. The examples use `source = "../.."`. Once a release is published, remote callers should pin an actual release tag; this repository does not assume an unpublished tag exists.

Select `home_region` from your tenancy configuration. It can differ from the workload region, as [example 03](examples/03-vcn-integration/README.md) demonstrates. Grant compartment-management permissions in the chosen parent through your existing IAM setup; this module does not grant itself permissions.

## ⚙️ Inputs

| Input | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `parent_compartment_id` | `string` | Yes | — | Parent compartment or tenancy OCID |
| `name` | `string` | Yes | — | Name without leading/trailing whitespace; unique in its parent |
| `description` | `string` | Yes | — | Description; empty string is allowed |
| `enable_delete` | `bool` | No | `false` | OCI provider deletion/adoption setting; see below |
| `defined_tags` | `map(string)` | No | `{}` | Existing namespace-qualified defined tags |
| `freeform_tags` | `map(string)` | No | `{}` | Free-form tags |

The parent OCID prefix must identify a tenancy or compartment. Actual existence, IAM authorization, naming constraints and tag namespace availability are checked by OCI. Optional null values resolve to their defaults; required inputs cannot be null.

## Deletion and adoption behavior

The [OCI provider contract](https://docs.oracle.com/en-us/iaas/tools/terraform-provider-oci/latest/docs/r/identity_compartment.html) couples deletion and name-collision behavior:

| `enable_delete` | Existing same-name compartment | Destroy |
| --- | --- | --- |
| `false` (default) | May be implicitly adopted and updated | Compartment remains in OCI while its state entry is removed |
| `true` | Creation rejects a name collision | Provider attempts to delete the compartment; it must be empty |

This flag is **not `prevent_destroy`**. Avoid separate states managing the same compartment. For disposable labs, decide on `enable_delete = true` before applying. Changing it later must first be applied before relying on its cleanup behavior. No operation recursively deletes contained workloads.

## 📤 Outputs

| Output | Description |
| --- | --- |
| `compartment_id` | OCID of this compartment, suitable for `compartment_ocid` in workload modules |
| `parent_compartment_id` | OCID of the parent compartment or tenancy |
| `name` | Compartment name |
| `description` | Compartment description |
| `state` | Lifecycle state reported by OCI |

## 🧩 Examples

| Example | Goal |
| --- | --- |
| [01: Single compartment](examples/01-single-compartment/README.md) | One compartment using a home-region provider |
| [02: Nested compartments](examples/02-nested-compartments/README.md) | Parent and two children using `for_each` |
| [03: VCN integration](examples/03-vcn-integration/README.md) | Pass the compartment OCID to FoggyKitchen VCN v0.2.0 with a separate workload-region provider |

See the [examples index](examples/README.md) for inputs and deployment commands. Each example has independent state. Choose distinct names or parents when running them in the same tenancy.

## Validation with OpenTofu

From the module root:

```sh
tofu init -backend=false
tofu fmt -recursive -check
tofu validate
tofu test
```

The [tests](tests/README.md) use mocked OCI and plan-only runs. They check defaults, pass-through inputs, output IDs, tags and validation without credentials or cloud changes. Validate each example separately. Each example also has a plan-only composition test for provider mapping and module outputs. No real `tofu apply`, destroy or compartment adoption is required to run the tests.

## Support and contributions

Read [SUPPORT.md](SUPPORT.md). Include sanitized reproduction steps, the affected example, OpenTofu/provider versions and relevant validation output in issues. Pull requests are welcome.

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**. See [LICENSE](LICENSE).

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
