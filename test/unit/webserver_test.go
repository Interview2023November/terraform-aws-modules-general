package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMyWebserver(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/virtual-machines/webserver",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
	publicIP := terraform.Output(t, terraformOptions, "public_ip")

	// Make sure the webserver indicates it is unavailable as it does not have its dependencies available.
	url := fmt.Sprintf("http://%s:8080", publicIP)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Without my database I am sad.", 30, 5*time.Second)
}
