# Example 03: VCN integration

Create a compartment through `oci.homeregion`, then pass its OCID to [FoggyKitchen VCN v0.2.0](https://github.com/foggykitchen/terraform-oci-fk-vcn/tree/v0.2.0) through `oci.workload`. Networking includes a VCN and one private subnet; it creates no compute, gateways or public endpoint.

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

Set both `home_region` and workload `region`. Outputs are `compartment_id`, `vcn_id` and `subnet_ids`. IAM propagation to the workload region can lag behind creation; the output dependency orders the operations but does not add a fixed delay.

## Cleanup

`enable_delete` defaults to false. Follow the [module deletion/adoption contract](../../README.md#deletion-and-adoption-behavior), review `tofu plan -destroy` and use `tofu destroy` when appropriate. Remove contained resources before attempting compartment deletion.

Configuration validation does not prove live IAM permissions or propagation. No actual credentials, state or plans belong in version control.

## Support and license

[All examples](../README.md) · [Module](../../README.md) · [Support policy](../../SUPPORT.md) · [UPL license](../../LICENSE)

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
