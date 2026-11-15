# Azure Infrastructure Deployment using Terraform

An Infrastructure as Code (IaC) project that provisions an Azure Linux Virtual Machine and its supporting network infrastructure using Terraform.

The project demonstrates automated provisioning of Azure resources, virtual networking, network security, and SSH-based access to a Linux virtual machine.

## Architecture

The infrastructure is deployed in **Azure East US**.

```text
                    Internet
                       |
                Static Public IP
                       |
                 Network Security
                   Group (NSG)
                       |
                Virtual Network
                  10.0.0.0/16
                       |
                 Subnet
                10.0.1.0/24
                       |
             Network Interface
                       |
               Ubuntu Linux VM
                 (Azure VM)
```

## Azure Resources Created

| Resource | Configuration |
|---|---|
| Resource Group | terraform-rg |
| Virtual Network | 10.0.0.0/16 |
| Subnet | 10.0.1.0/24 |
| Network Security Group | terraform-nsg |
| Public IP | Static, Standard SKU |
| Network Interface | Connected to subnet and public IP |
| Virtual Machine | Standard_F1als_v7 |
| Operating System | Ubuntu Server 24.04 LTS |
| OS Disk | Standard_LRS |

## Network Security

The Network Security Group contains the following inbound rules:

| Port | Protocol | Source | Purpose |
|---|---|---|---|
| 80 | TCP | Internet | HTTP traffic |
| 22 | TCP | Configured public IP (/32) | SSH access |

SSH access is restricted to a specific public IP address rather than being exposed to the entire Internet.

## Technology Stack

- Microsoft Azure
- Terraform
- Azure Resource Manager (AzureRM) Provider
- Azure CLI
- Ubuntu Linux
- SSH

## Project Structure

```text
azure-terraform-vm-deployment/
│
├── main.tf                 # Resource Group
├── provider.tf             # Terraform and Azure provider configuration
├── network.tf              # Virtual Network and Subnet
├── security.tf             # NSG, inbound rules and subnet association
├── vm.tf                   # Public IP, NIC and Linux VM
├── variable.tf             # Input variables
├── .terraform.lock.hcl     # Provider dependency lock file
├── .gitignore
└── README.md
```

## Prerequisites

Before deploying, ensure you have:

1. An active Microsoft Azure subscription.
2. [Terraform](https://developer.hashicorp.com/terraform/install) installed.
3. [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed.
4. An SSH key pair available locally.

Generate an SSH key if you don't already have one:

```bash
ssh-keygen -t ed25519 -C "azure-vm"
```

The Terraform configuration expects the public key at:

```text
~/.ssh/id_ed25519.pub
```

## Deployment Instructions

### 1. Clone the repository

```bash
git clone https://github.com/visshxl/azure-terraform-vm-deployment.git

cd azure-terraform-vm-deployment
```

### 2. Authenticate with Azure

```bash
az login
```

Select the appropriate subscription:

```bash
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

Update the `subscription_id` in `provider.tf` to match your Azure subscription.

### 3. Configure SSH access

In `security.tf`, update the SSH rule's `source_address_prefix` to your current public IP address in CIDR notation (`/32`).

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Validate the configuration

```bash
terraform validate
```

### 6. Review the execution plan

```bash
terraform plan
```

### 7. Deploy the infrastructure

```bash
terraform apply
```

Review the proposed changes and confirm when prompted.

## Connecting to the Virtual Machine

After deployment, retrieve the VM's public IP address from the Azure Portal.

Connect using SSH:

```bash
ssh azureuser@<PUBLIC_IP>
```

The VM uses SSH public-key authentication.

## Cleanup

To avoid unnecessary Azure charges, destroy the resources when they are no longer required:

```bash
terraform destroy
```

Review the resources Terraform proposes to destroy before confirming.

## Important Notes

- Terraform state files are excluded from version control.
- The `.terraform.lock.hcl` file is committed to maintain provider dependency consistency.
- SSH access is restricted by an NSG rule.
- The HTTP port is allowed, but a web server or application is not automatically installed by this configuration.
- Azure resource pricing depends on the selected region, VM size, and resource usage.

---

**Author:** [visshxl](https://github.com/visshxl)

**Repository:** [azure-terraform-vm-deployment](https://github.com/visshxl/azure-terraform-vm-deployment)