# -- main.tf
# ============================================================================
# AWS Glue Database Resource
# Creates and manages an AWS Glue Data Catalog database
# ============================================================================

resource "aws_glue_catalog_database" "this" {
  name         = var.glue_database_config.name
  catalog_id   = var.glue_database_config.catalog_id
  description  = var.glue_database_config.description
  location_uri = var.glue_database_config.location_uri

  dynamic "create_table_default_permission" {
    for_each = var.glue_database_config.create_table_default_permission != null ? [var.glue_database_config.create_table_default_permission] : []
    content {
      permissions = create_table_default_permission.value.permissions

      dynamic "principal" {
        for_each = create_table_default_permission.value.principal != null ? [create_table_default_permission.value.principal] : []
        content {
          data_lake_principal_identifier = principal.value.data_lake_principal_identifier
        }
      }
    }
  }

  dynamic "federated_database" {
    for_each = var.glue_database_config.federated_database != null ? [var.glue_database_config.federated_database] : []
    content {
      connection_name = federated_database.value.connection_name
      identifier      = federated_database.value.identifier
    }
  }

  dynamic "target_database" {
    for_each = var.glue_database_config.target_database != null ? [var.glue_database_config.target_database] : []
    content {
      catalog_id    = target_database.value.catalog_id
      database_name = target_database.value.database_name
      region        = target_database.value.region
    }
  }

  parameters = var.glue_database_config.parameters

  tags = var.glue_database_config.tags
}
