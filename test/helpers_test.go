// File: test/helpers_test.go
package test

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/glue"
	"github.com/stretchr/testify/require"
)

type GlueDatabaseProps struct {
	Name        string
	Description string
	LocationURI string
	CatalogID   string
}

func getGlueClient(t *testing.T) *glue.Client {
	t.Helper()

	region := os.Getenv("AWS_REGION")
	if region == "" {
		region = "us-east-1"
	}

	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(region))
	require.NoError(t, err, "Failed to load AWS config")

	return glue.NewFromConfig(cfg)
}

func databaseExists(t *testing.T, client *glue.Client, databaseName string) bool {
	t.Helper()

	_, err := client.GetDatabase(context.TODO(), &glue.GetDatabaseInput{
		Name: &databaseName,
	})

	return err == nil
}

func fetchDatabaseProps(t *testing.T, client *glue.Client, databaseName string) GlueDatabaseProps {
	t.Helper()

	output, err := client.GetDatabase(context.TODO(), &glue.GetDatabaseInput{
		Name: &databaseName,
	})
	require.NoError(t, err, "Failed to get database")

	props := GlueDatabaseProps{
		Name: *output.Database.Name,
	}

	if output.Database.Description != nil {
		props.Description = *output.Database.Description
	}

	if output.Database.LocationUri != nil {
		props.LocationURI = *output.Database.LocationUri
	}

	if output.Database.CatalogId != nil {
		props.CatalogID = *output.Database.CatalogId
	}

	return props
}

func mustEnv(t *testing.T, key string) string {
	t.Helper()
	v := strings.TrimSpace(os.Getenv(key))
	require.NotEmpty(t, v, "Missing required environment variable %s", key)
	return v
}

func stringPtr(s string) *string {
	return &s
}
