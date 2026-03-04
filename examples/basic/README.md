# Basic AWS Glue Database Example

This example creates a basic AWS Glue Data Catalog database.

## Usage

```bash
terraform init
terraform plan -var='glue_database={"name":"my_database"}'
terraform apply -var='glue_database={"name":"my_database"}'
```

## With Description

```bash
terraform apply -var='glue_database={"name":"my_database","description":"My data catalog database"}'
```
