package test

import (
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

// TestExamplesComplete tests a typical deployment of this module
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/complete",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	logger.Log(t, "Testing HTTP and HTTPS redirects")
	checkRedirect(t, "http://terraform-aws-redirect.oss.champtest.net/", "https://github.com:443/search?q=aws")
	checkRedirect(t, "https://terraform-aws-redirect.oss.champtest.net/", "https://github.com:443/search?q=aws")
}

func checkRedirect(t *testing.T, url string, expected string) {
	logger.Log(t, "Testing redirect for :", url)
	resp, err := http.Get(url)
	assert.Nil(t, err)
	assert.Equal(t, 200, resp.StatusCode)

	logger.Log(t, "Checking if redirect works with host, path, query for:", expected)
	assert.Equal(t, expected, resp.Request.URL.String())
}
