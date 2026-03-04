# -- examples/with-location/outputs.tf
# ============================================================================
# Example Outputs
# ============================================================================

output "database_id" {
  description = "The ID of the Glue Catalog database"
  value       = module.glue_database.database_id
}

output "database_name" {
  description = "The name of the Glue Catalog database"
  value       = module.glue_database.database_name
}

output "database_arn" {
  description = "The ARN of the Glue Catalog database"
  value       = module.glue_database.database_arn
}

output "location_uri" {
  description = "The location URI of the database"
  value       = module.glue_database.location_uri
}
