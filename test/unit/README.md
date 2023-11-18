# test

The `test` directory holds [terratest](https://terratest.gruntwork.io/) content used to test our modules.

To run all of the tests use `go test -v -timeout 30m`.
To run a particular test add `-run` and the name of the test as an argument.
(ie: `go test -v -timeout 30m -run TestMysql`)
