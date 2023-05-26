# backend-init

This Terraform plan creates a bucket in OCI under the specified compartment, namespace, and bucket name.

The purpose of this plan is to create a bucket in OCI object storage so that the rest of your Terraform plans can store their state inside there. Note that the state for THIS Terraform plan is entirely local, and if you lose it, you're screwed, but you probably only ever have to execute this ONCE per OCI account.

If executed with the example tfvars, it will produce the following bucket and object:


```
https://objectstorage.<YOUR_HOME_REGION>.oraclecloud.com/n/<YOUR_NAMESPACE>/b/<YOUR_BUCKET>/<YOUR_STAETE_FOLDER>/terraform.tfstate
```

For example:

```
https://objectstorage.us-sanjose-1.oraclecloud.com/n/axvx3egocaah/b/terraform-state/vps-tfstate/terraform.tfstate
```

Once this file is created, you need to go to the Oracle Cloud web console and create a Pre-Authenticated request URL for it.
You can then specify that request URL as the HTTP backend for your Terraform state.

More reading:

- [Terraform State with OCI Object Store](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.html)
- [OCI Pre-Authenticated Requests](https://docs.oracle.com/en-us/iaas/Content/Object/Tasks/usingpreauthenticatedrequests.htm#Using_PreAuthenticated_Requests)

