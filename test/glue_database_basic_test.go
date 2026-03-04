// File: test/glue_database_basic_test.go
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

// TestGlueDatabaseBasic tests creating a basic Glue database
func TestGlueDatabaseBasic(t *testing.T) {
	t.Parallel()

	retrySleep := 5 * time.Second
	unique := strings.ToLower(random.UniqueId())
	databaseName := fmt.Sprintf("tt_glue_basic_%s", unique)

	tfDir := "../examples/basic"

	glueConfig := map[string]interface{}{
		"name": databaseName,
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

	exists := databaseExists(t, client, databaseName)
	require.True(t, exists, "Expected database %q to exist", databaseName)

	outputDatabaseName := terraform.Output(t, tfOptions, "database_name")
	require.Equal(t, databaseName, outputDatabaseName)
}
