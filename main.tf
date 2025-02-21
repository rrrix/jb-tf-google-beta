/*
Jetbrains IDE Google Cloud Terraform Beta Provider Confusion Example

https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/guides/provider_versions
*/


/*
The `google_project_service_identity` is not recognized by the IDE, despite being a valid google-beta resource type:
https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/project_service_identity

Results in Inspection Warning:
For the provider "hashicorp/google", resource "google_project_service_identity" is not defined
 */
resource "google_project_service_identity" "default" {
  provider = google-beta
  service  = "compute.googleapis.com" // Warning: Unknown property service
}

/*
The resource type `google-beta_project_service_identity` is recognized by the IDE, however is NOT a valid resource type!
 */
resource "google-beta_project_service_identity" "default" {
  provider = google-beta
  service  = "compute.googleapis.com"
}
