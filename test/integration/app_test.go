package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMyApp(t *testing.T) {
	t.Parallel()

	// Create dependencies we need to test SSH access
	awsRegion := "us-east-2"
	uniqueID := random.UniqueId()
	keyPairName := fmt.Sprintf("terratest-app-example-%s", uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, awsRegion, keyPairName)
	defer aws.DeleteEC2KeyPair(t, keyPair)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/integration/app-3-tier",

		// Variables for our terraform call
		Vars: map[string]interface{}{
			"key_name":    keyPairName,
			"region":      awsRegion,
			"db_username": "username",
			"db_password": "username",
			"db_name":     "example_db",
		},
	})
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
	bastionPublicIP := terraform.Output(t, terraformOptions, "bastion_public_ip")
	backendPrivateIP := terraform.Output(t, terraformOptions, "webserver_ip")

	// Make sure we can make the SSH-hop from the bastion to the backend server
	publicHost := ssh.Host{
		Hostname:    bastionPublicIP,
		SshKeyPair:  keyPair.KeyPair,
		SshUserName: "ubuntu",
	}
	privateHost := ssh.Host{
		Hostname:    backendPrivateIP,
		SshKeyPair:  keyPair.KeyPair,
		SshUserName: "ubuntu",
	}

	// Retry until ssh is available
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("SSH to private host %s via bastion %s", backendPrivateIP, bastionPublicIP)

	expectedText := "Backend reached."
	command := fmt.Sprintf("echo -n '%s'", expectedText)

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckPrivateSshConnectionE(t, publicHost, privateHost, command)

		if err != nil {
			return "", err
		}

		if strings.TrimSpace(actualText) != expectedText {
			return "", fmt.Errorf("Expected SSH command to return '%s' but got '%s'", expectedText, actualText)
		}

		return "", nil
	})

	appURL := terraform.Output(t, terraformOptions, "app_url")

	// Make sure the webserver has its dependencies available.
	http_helper.HttpGetWithRetry(t, appURL, nil, 200, "I can reach the database, things are good.", 30, 5*time.Second)
}
