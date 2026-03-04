// File: test/glue_database_with_location_test.go
package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// TestGlueDatabaseWithLocation tests creating a Glue database with location URI
func TestGlueDatabaseWithLocation(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	databaseName := fmt.Sprintf("tt_glue_loc_%s", unique)
	locationURI := fmt.Sprintf("s3://test-bucket-%s/data/", unique)

	tfDir := "../examples/with-location"

	glueConfig := map[string]interface{}{
		"name":         databaseName,
		"description":  "Test database with location",
		"location_uri": locationURI,
	}

	tfOptions := &terraform.Options{
		TerraformDir: tfDir,
		NoColor:      true,
		Vars: map[string]interface{}{
			"region":        "us-east-1",
			"glue_database": glueConfig,
		},
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	time.Sleep(retrySleep)

	client := getGlueClient(t)

	props := fetchDatabaseProps(t, client, databaseName)
	require.Equal(t, databaseName, props.Name)
	require.Equal(t, "Test database with location", props.Description)
	require.Equal(t, locationURI, props.LocationURI)

	outputLocationURI := terraform.Output(t, tfOptions, "location_uri")
	require.Equal(t, locationURI, outputLocationURI)
}
