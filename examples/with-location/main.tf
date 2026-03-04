# -- examples/with-location/main.tf
# ============================================================================
# Example: AWS Glue Database with S3 Location
# ============================================================================

module "glue_database" {
  source = "../.."

  glue_database_config = var.glue_database
}
