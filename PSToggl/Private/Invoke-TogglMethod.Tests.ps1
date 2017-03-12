# Credit to header goes to replicaJunction
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

#InModuleScope PSToggl {
Describe "Invoke-TogglMethod" {
	Mock Invoke-WebRequest {

	}

	It "Performs a GET Request for empty InputObject" {

	}

	It "Performs a POST Request if an InputObject is given" {

	}

	It "Returns the data attribute of the API Response if it succeeded" {

	}
}
#}
