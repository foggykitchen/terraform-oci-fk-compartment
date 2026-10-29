# Compartment contract tests

Tests use mocked OCI resources and plan-only runs, with no cloud credentials or infrastructure changes. They assert the provider flag and configuration; they do not simulate real deletion, implicit adoption, IAM authorization or propagation.

From the module root:

```sh
tofu init -backend=false
tofu validate
tofu test
```

Use an OpenTofu release with mock-provider support (verified with OpenTofu 1.11.6). The module retains a Terraform/OpenTofu `>= 1.6.0` requirement.

The 10 cases check deletion opt-in/defaults, tags, tenancy and compartment parents, unchanged name/description, correct output IDs, empty descriptions, optional null defaults and rejection of invalid parent/name inputs.

Initialize and validate the [three examples](../examples/README.md) separately. Live creation, adoption and deletion need an explicitly selected OCI environment.


## Example composition tests

Each example has `tests/composition.tftest.hcl`. Run `tofu init -backend=false`, `tofu validate` and `tofu test` from that example directory. These three additional plan-only tests cover home-region provider injection, parent/child relationships and a separate workload provider for VCN integration. All OCI inputs are synthetic; no real tfvars file is needed.

[Module documentation](../README.md) · [Support policy](../SUPPORT.md) · [UPL license](../LICENSE)

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
