# terraform VPS

This Terraform plan brings up a VPS under OCI. The example configuration creates a VPS that falls under the "always free" tier.

By default, it uses 3 ARM cores, 16 GB of RAM, and 180 GB of block storage.

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

## upon initial creation

You'll need to SSH into the instance and perform some initial commands:

```shell
# format the block volume with ext4 (WARNING: will wipe its data)
sudo mkfs.ext4 /dev/oracleoci/oraclevdb

# have it automount on reboot
mkdir -p /mnt/storage
echo '/dev/oracleoci/oraclevdb /mnt/storage ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
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
