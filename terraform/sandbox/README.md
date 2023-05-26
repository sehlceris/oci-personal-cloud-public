# terraform VPS

This Terraform plan brings up 2 networked x86 VPS, with 1GB RAM, and no block storage, under OCI.
It's meant to create a sandbox/playground using the 2 relatively weak x86 servers you are given under the free tier.

## initializing

This plan uses OCI object storage to manage the Terraform state.

Run the plan in `backend-init` folder if you haven't already to create the state bucket, and then create and update the `backend.tfvars` with your pre-authenticated request URL.

Then, initialize:

```shell
terraform init -backend-config=backend.tfvars
```

## updating and running the plan

Copy `terraform.tfvars.example` to `terraform.tfvars` and edit it to your specifications.

```shell
terraform plan
terraform apply
```

## script to retry if out of host capacity

If you're on the Oracle Free plan, you may get an error

```
500-InternalError, Out of host capacity.
```

Here is a bash script to retry your Terraform apply command until it works:

```shell
while ! terraform apply -auto-approve
do
    echo "$(date) | FAILED. waiting to retry terraform apply..."
    sleep 120
done
```

## useful commands

```shell
# retrieve your VPS IP address
terraform apply -refresh-only
```
