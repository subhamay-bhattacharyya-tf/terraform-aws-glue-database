# -- variables.tf
# ============================================================================
# AWS Glue Database Module - Variables
# ============================================================================

variable "glue_database_config" {
  description = "Configuration object for AWS Glue Data Catalog database"
  type = object({
    name         = string
    catalog_id   = optional(string, null)
    description  = optional(string, null)
    location_uri = optional(string, null)
    parameters   = optional(map(string), null)
    tags         = optional(map(string), {})

    create_table_default_permission = optional(object({
      permissions = optional(list(string), ["ALL"])
      principal = optional(object({
        data_lake_principal_identifier = optional(string, "IAM_ALLOWED_PRINCIPALS")
      }), null)
    }), null)

    federated_database = optional(object({
      connection_name = string
      identifier      = string
    }), null)

    target_database = optional(object({
      catalog_id    = string
      database_name = string
      region        = optional(string, null)
    }), null)
  })

  validation {
    condition     = length(var.glue_database_config.name) > 0
    error_message = "Database name must not be empty."
  }

  validation {
    condition     = length(var.glue_database_config.name) <= 255
    error_message = "Database name must be 255 characters or less."
  }

  validation {
    condition     = can(regex("^[a-z0-9_]+$", var.glue_database_config.name))
    error_message = "Database name must contain only lowercase letters, numbers, and underscores."
  }

  validation {
    condition     = var.glue_database_config.federated_database == null || var.glue_database_config.target_database == null
    error_message = "Cannot specify both federated_database and target_database."
  }
}
