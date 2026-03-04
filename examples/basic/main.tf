# -- examples/basic/main.tf
# ============================================================================
# Example: Basic AWS Glue Database
# ============================================================================

module "glue_database" {
  source = "../.."

  glue_database_config = var.glue_database
}
