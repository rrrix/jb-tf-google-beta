# Jetbrains IDE Google Cloud Terraform Beta Provider Confusion Example

The JetBrains [Terraform/OpenTofu Plugin](https://www.jetbrains.com/help/idea/terraform.html) gets confused when
dealing with Terraform resources using the Terraform Google Cloud Beta provider (`google-beta`). 

## Background

Google Publishes two versions of the Google Cloud Terraform Provider - the standard [`google`] provider and the 
[`google-beta`] provider. The `google-beta` provider includes beta and experimental features that are not yet part of the stable `google` provider.

The `google-beta` provider includes both resources and resource fields which are _not_ included in the `google` (GA) 
provider. This results in a difference in the resulting Provider Metadata.

Both providers use resource names prefixed with `google_`, and the beta provider can only be used by 
explicitly setting the `provider = google-beta` field. 

## Beta-Provider-Only Resource

The following example using [google_project_service_identity] currently produces two IDE inspection warnings:

* For the provider "hashicorp/google", resource "google_project_service_identity" is not defined
* Unknown property service

```terraform
resource "google_project_service_identity" "default" {
  provider = google-beta // Explicitly specified beta provider is ignored by IDE
  service  = "compute.googleapis.com"
}
```

Curiously, how can the IDE know what properties are valid on a resource if doesn't recognize the resource?

## IDE incorrectly associates google-beta resources with a "google-beta_" resource name prefix 

This should result in an IDE warning `Unknown resource: "google-beta_project_service_identity"`. 
Produces *no warnings*.

```terraform
resource "google-beta_project_service_identity" "default" {
  service  = "compute.googleapis.com"
}
```
## Example Screenshot

![example.png](.github/assets/example.png)


## Beta-Only Data Sources & Resources

As of 2025-02-20, the following data sources and resources are available _only_ in the `google-beta` provider.

Extracted from [GoogleCloudPlatform/magic-modules/mmv1/third_party/terraform/provider/provider_mmv1_resources.go.
tmpl](https://github.com/GoogleCloudPlatform/magic-modules/blob/main/mmv1/third_party/terraform/provider/provider_mmv1_resources.go.tmpl)

### Beta-Only Data Sources

* `google_cloud_asset_resources_search_all`
* `google_firebase_android_app`
* `google_firebase_apple_app`
* `google_firebase_hosting_channel`
* `google_firebase_web_app`
* `google_kms_autokey_config`
* `google_kms_key_handle`
* `google_kms_key_handles`
* `google_kms_secret_asymmetric`
* `google_parameter_manager_parameter_version_render`
* `google_parameter_manager_parameter_version`
* `google_parameter_manager_parameter`
* `google_parameter_manager_parameters`
* `google_parameter_manager_regional_parameter_version_render`
* `google_parameter_manager_regional_parameter_version`
* `google_parameter_manager_regional_parameter`
* `google_parameter_manager_regional_parameters`
* `google_runtimeconfig_config`
* `google_runtimeconfig_variable`
* `google_tpu_v2_accelerator_types`
* `google_tpu_v2_runtime_versions`

### Beta-Only Resources

* `google_compute_instance_from_machine_image`
* `google_dataflow_flex_template_job`
* `google_project_service_identity`
* `google_runtimeconfig_config`
* `google_runtimeconfig_variable`


[`google`]: https://github.com/hashicorp/terraform-provider-google
[`google-beta`]: https://github.com/hashicorp/terraform-provider-google-beta
[google_project_service_identity]: https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/project_service_identity
