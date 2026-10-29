# Compartment examples

Each example uses the local module checkout and its own state. They are independent configurations, not sequential state upgrades.

| Example | Goal |
| --- | --- |
| [01: Single compartment](01-single-compartment/README.md) | Basic module inputs and outputs |
| [02: Nested compartments](02-nested-compartments/README.md) | Parent/child dependencies and `for_each` |
| [03: VCN integration](03-vcn-integration/README.md) | Home-region IAM combined with a workload-region VCN |

## Requirements and inputs

Use OpenTofu >= 1.6, Git and OCI API-key authentication with compartment-management permissions on the chosen parent. Example 03 also needs networking permissions and downloads VCN v0.2.0.

Copy `terraform.tfvars.example` in the selected example and set tenancy/user OCIDs, fingerprint, private-key path, `home_region` and `parent_compartment_id`. The parent can be an existing compartment or the tenancy. Example 03 also requires `region` for networking. The module itself contains no provider credentials.

## Run with OpenTofu

```sh
cd 01-single-compartment # or 02-nested-compartments / 03-vcn-integration
cp terraform.tfvars.example terraform.tfvars
# Edit the copied file.
tofu init
tofu fmt -check
tofu validate
tofu plan -out=example.tfplan
# Review before modifying OCI.
tofu apply example.tfplan
tofu output
```

Keep real variable files, keys, state and plans out of Git. Use unique compartment names or separate parents to avoid implicit adoption of another example's resources.

## Cleanup

Read the [deletion/adoption contract](../README.md#deletion-and-adoption-behavior) before deployment. `enable_delete` defaults to false; compartment retention is intentional. Review `tofu plan -destroy` before `tofu destroy`. Empty compartments are required for opted-in deletion, including child compartments in example 02 and networking resources in example 03.

## Support and license

[Module documentation](../README.md) · [Support policy](../SUPPORT.md) · [UPL license](../LICENSE)

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
