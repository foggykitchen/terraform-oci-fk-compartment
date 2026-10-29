# Example 02: Nested compartments

Create a `FoggyKitchenTraining` parent with `application` and `data` children. `for_each` creates the children, using `module.parent.compartment_id` as their parent. That output reference establishes the dependency without a manual sleep.

## Requirements and inputs

Use OpenTofu >= 1.6 and the OCI API-key/permission setup in the [examples index](../README.md#requirements-and-inputs). Copy and edit this directory's input template. The examples use the local compartment module at `../..`.

## Run

```sh
cp terraform.tfvars.example terraform.tfvars
# Edit your OCI values and choose enable_delete deliberately.
tofu init
tofu fmt -check
tofu validate
tofu plan -out=example.tfplan
# Review before applying.
tofu apply example.tfplan
tofu output
```

Outputs are the created `parent_compartment_id` and the `child_compartment_ids` map. Compartment operations use the same home-region provider.

## Cleanup

`enable_delete` defaults to false. Follow the [module deletion/adoption contract](../../README.md#deletion-and-adoption-behavior), review `tofu plan -destroy` and use `tofu destroy` when appropriate. Remove contained resources before attempting compartment deletion.

Configuration validation does not prove live IAM permissions or propagation. No actual credentials, state or plans belong in version control.

## Support and license

[All examples](../README.md) · [Module](../../README.md) · [Support policy](../../SUPPORT.md) · [UPL license](../../LICENSE)

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
