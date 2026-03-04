# -- outputs.tf
# ============================================================================
# AWS Glue Database Module - Outputs
# ============================================================================

output "database_id" {
  description = "The ID of the Glue Catalog database (catalog_id:name)."
  value       = aws_glue_catalog_database.this.id
}

output "database_name" {
  description = "The name of the Glue Catalog database."
  value       = aws_glue_catalog_database.this.name
}

output "database_arn" {
  description = "The ARN of the Glue Catalog database."
  value       = aws_glue_catalog_database.this.arn
}

output "catalog_id" {
  description = "The ID of the Data Catalog in which the database resides."
  value       = aws_glue_catalog_database.this.catalog_id
}

output "location_uri" {
  description = "The location of the database (S3 path)."
  value       = aws_glue_catalog_database.this.location_uri
}

output "description" {
  description = "The description of the database."
  value       = aws_glue_catalog_database.this.description
}
