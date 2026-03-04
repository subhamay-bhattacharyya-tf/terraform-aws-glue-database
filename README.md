# Terraform AWS Glue Database Module

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-database/actions/workflows/ci.yaml/badge.svg)&nbsp;![AWS](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-aws-glue-database)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-aws-glue-database)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-aws-glue-database)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-aws-glue-database)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-aws-glue-database)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-aws-glue-database)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-aws-glue-database)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/d38e95a090be70513f16e3b1a3529d76/raw/terraform-aws-glue-database.json?)

A Terraform module for creating and managing AWS Glue Data Catalog databases with support for federated databases, resource links, and Lake Formation permissions.

## Features

- Object-style configuration input
- Optional S3 location URI
- Lake Formation default table permissions
- Federated database support
- Resource link (target database) support
- Custom parameters
- Built-in input validation

## Usage

### Basic Glue Database

```hcl
module "glue_database" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-database?ref=main"

  glue_database_config = {
    name = "my_database"
  }
}
```

### Glue Database with Description and Location

```hcl
module "glue_database" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-database?ref=main"

  glue_database_config = {
    name         = "analytics_database"
    description  = "Database for analytics data"
    location_uri = "s3://my-data-bucket/analytics/"
  }
}
```

### Glue Database with Tags

```hcl
module "glue_database" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-database?ref=main"

  glue_database_config = {
    name        = "production_database"
    description = "Production data catalog"
    tags = {
      Environment = "production"
      Team        = "data-engineering"
    }
  }
}
```

### Glue Database with Lake Formation Permissions

```hcl
module "glue_database" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-database?ref=main"

  glue_database_config = {
    name = "secure_database"
    create_table_default_permission = {
      permissions = ["SELECT", "ALTER"]
      principal = {
        data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
      }
    }
  }
}
```

### Resource Link to Another Database

```hcl
module "glue_database" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-aws-glue-database?ref=main"

  glue_database_config = {
    name = "linked_database"
    target_database = {
      catalog_id    = "123456789012"
      database_name = "source_database"
      region        = "us-west-2"
    }
  }
}
```

### Using JSON Input

```bash
terraform apply -var='glue_database_config={"name":"my_database","description":"My data catalog","location_uri":"s3://bucket/path/"}'
```

## Examples

| Example | Description |
|---------|-------------|
| [basic](examples/basic) | Simple Glue database |
| [with-location](examples/with-location) | Glue database with S3 location |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| glue_database_config | Configuration object for AWS Glue database | `object` | - | yes |

### glue_database_config Object Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| name | string | - | Name of the database (required, lowercase letters, numbers, underscores only) |
| catalog_id | string | null | ID of the Data Catalog (defaults to AWS account ID) |
| description | string | null | Description of the database |
| location_uri | string | null | S3 location of the database |
| parameters | map(string) | null | Key-value parameters for the database |
| tags | map(string) | {} | Tags to apply to the database |
| create_table_default_permission | object | null | Default Lake Formation permissions for tables |
| federated_database | object | null | Federated database configuration |
| target_database | object | null | Resource link target database configuration |

### create_table_default_permission Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| permissions | list(string) | ["ALL"] | Permissions to grant (ALL, SELECT, ALTER, DROP, DELETE, INSERT) |
| principal.data_lake_principal_identifier | string | "IAM_ALLOWED_PRINCIPALS" | Principal identifier |

### federated_database Object

| Property | Type | Description |
|----------|------|-------------|
| connection_name | string | Name of the connection to the external metastore |
| identifier | string | Unique identifier for the federated database |

### target_database Object

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| catalog_id | string | - | Catalog ID of the target database |
| database_name | string | - | Name of the target database |
| region | string | null | Region of the target database |

## Outputs

| Name | Description |
|------|-------------|
| database_id | The ID of the Glue Catalog database (catalog_id:name) |
| database_name | The name of the Glue Catalog database |
| database_arn | The ARN of the Glue Catalog database |
| catalog_id | The ID of the Data Catalog |
| location_uri | The location of the database (S3 path) |
| description | The description of the database |

## Resources Created

| Resource | Description |
|----------|-------------|
| aws_glue_catalog_database | The Glue Data Catalog database |

## Validation

The module validates inputs and provides descriptive error messages for:

- Empty database name
- Database name exceeding 255 characters
- Invalid characters in database name (only lowercase, numbers, underscores allowed)
- Conflicting federated_database and target_database configurations

## Testing

The module includes Terratest-based integration tests:

```bash
cd test
go mod tidy
go test -v -timeout 30m
```

### Test Cases

| Test | Description |
|------|-------------|
| TestGlueDatabaseBasic | Basic database creation |
| TestGlueDatabaseWithLocation | Database with S3 location URI |

AWS credentials must be configured via environment variables or AWS CLI profile.

## License

MIT License - See [LICENSE](LICENSE) for details.
