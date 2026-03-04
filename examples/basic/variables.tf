# -- examples/basic/variables.tf
# ============================================================================
# Example Variables
# ============================================================================

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "glue_database" {
  description = "Glue database configuration"
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
}
