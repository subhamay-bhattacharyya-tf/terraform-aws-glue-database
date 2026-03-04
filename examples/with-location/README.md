# AWS Glue Database with S3 Location Example

This example creates an AWS Glue Data Catalog database with an S3 location URI.

## Usage

```bash
terraform init
terraform plan -var='glue_database={"name":"my_database","location_uri":"s3://my-bucket/data/"}'
terraform apply -var='glue_database={"name":"my_database","location_uri":"s3://my-bucket/data/"}'
```

## With Description and Tags

```bash
terraform apply -var='glue_database={"name":"my_database","location_uri":"s3://my-bucket/data/","description":"Database for analytics","tags":{"Environment":"dev"}}'
```
