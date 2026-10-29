# Example 01: Single compartment

Create one compartment under an existing parent or tenancy. The root configuration passes `oci.homeregion` to the module.

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

Outputs are `compartment_id` and `compartment_name`. The former identifies the newly managed compartment, not the parent.

## Cleanup

`enable_delete` defaults to false. Follow the [module deletion/adoption contract](../../README.md#deletion-and-adoption-behavior), review `tofu plan -destroy` and use `tofu destroy` when appropriate. Remove contained resources before attempting compartment deletion.

Configuration validation does not prove live IAM permissions or propagation. No actual credentials, state or plans belong in version control.

## Support and license

[All examples](../README.md) · [Module](../../README.md) · [Support policy](../../SUPPORT.md) · [UPL license](../../LICENSE)

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
