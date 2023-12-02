package test

import (
	"fmt"
	"strconv"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestMysql(t *testing.T) {
	t.Parallel()

	// Assign a unique name for identification and collision prevention
	expectedName := fmt.Sprintf("terratest-mysql-example-%s", strings.ToLower(random.UniqueId()))
	expectedPort := int64(3306)
	expectedDatabaseName := "test_database"
	username := "username"
	password := "password" //gitleaks:allow

	// For simplicity, stick to the us-east-2 region. In actual applications we'd want to randomize this.
	awsRegion := "us-east-2"

	// Construct the terraform options
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../../examples/data-stores/mysql",

		// Variables for our terraform call
		Vars: map[string]interface{}{
			"name":        expectedName,
			"db_username": username,
			"db_password": password,
			"db_name":     expectedDatabaseName,
			"port":        expectedPort,
			"region":      awsRegion,
		},
	})

	// Aalways run at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Look up the connection info and verify our database exists
	address := terraform.Output(t, terraformOptions, "address")
	portstr := terraform.Output(t, terraformOptions, "port")
	port, err := strconv.ParseInt(portstr, 10, 64)
	if err != nil {
		t.Fatal(err)
	}
	schemaExistsInRdsInstance := aws.GetWhetherSchemaExistsInRdsMySqlInstance(t, address, port, username, password, expectedDatabaseName)

	// Verify we have a mysql at some address listening on our expected port with the database we defined.
	assert.NotNil(t, address)
	assert.Equal(t, expectedPort, port)
	assert.True(t, schemaExistsInRdsInstance)
}
