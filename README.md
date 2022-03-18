# Terraform Configuration for Azure


## Purpose:

To create Azure resources using Terraform.

## Prerequisites.

- [Install Terraform](https://www.terraform.io/downloads) 
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) and Login

## Terraform deployment

### Clone the Repository

- Clone the Repository to your local machine

```bash
git clone https://github.com/Jul2021/AzureTF.git
```

This will download the configuration (code) onto your local machine in a folder named as AzureTF

### Variables

Rename the file `terraformtfvarsdummy` to `terraform.tfvars` and update the values for the deployment as desired. 


### Initiailization 

Once the `terraform.tfvars` is updated, run the below command to initialize terraform

```bash
terraform init
```

### Deployment

To deploy the Infrastructure on your Azure subscription, run the below command

```bash
terraform apply
```

This will give you the list of resources that are going to be created and prompt you for confirmation. Type `yes` to proceed with the deployment.

### Outputs

After the deployment is completed, Terraform will print the outputs, in this case, it will print
the bastion IP and Web Public IPs



