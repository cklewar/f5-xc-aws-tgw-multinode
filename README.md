# F5-XC-AWS-TGW-MULTINODE

This repository consists of Terraform templates to bring up a F5XC AWS TGW multi node environment.

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/f5-xc-aws-tgw-multinode`
- Enter repository directory with: `cd f5-xc-aws-tgw-multinode`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

### Example Output

```bash
module.aws_tgw_multi_node.volterra_tf_params_action.aws_tgw_action: Creation complete after 15m37s [id=f96dbc25-3581-4e48-9d64-db2ca3cd4c1c]
module.aws_tgw_multi_node.data.aws_vpc.tgw_vpc: Reading...
module.aws_tgw_multi_node.data.aws_instance.ce_master: Reading...
module.aws_tgw_multi_node.data.aws_ec2_transit_gateway.tgw: Reading...
module.aws_tgw_multi_node.data.aws_ec2_transit_gateway.tgw: Read complete after 1s [id=tgw-0887077accc0cc9d8]
module.aws_tgw_multi_node.data.aws_vpc.tgw_vpc: Read complete after 1s [id=vpc-05d58d648006d08aa]
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_workload["node2"]: Reading...
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_workload["node0"]: Reading...
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_slo["node0"]: Reading...
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_workload["node1"]: Reading...
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_slo["node1"]: Reading...
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_sli: Reading...
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_slo["node2"]: Reading...
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_workload["node1"]: Read complete after 0s [id=subnet-0962628cece15f405]
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_slo["node0"]: Read complete after 1s [id=subnet-0e8b80781a80c42db]
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_slo["node1"]: Read complete after 1s [id=subnet-047027533cf9398b6]
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_workload["node0"]: Read complete after 1s [id=subnet-09d0b7a17ee2c9cfc]
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_workload["node2"]: Read complete after 1s [id=subnet-0442b34fc4d4bff5a]
module.aws_tgw_multi_node.data.aws_subnet.tgw_subnet_slo["node2"]: Read complete after 1s [id=subnet-0db90d73a1dd4df77]
module.aws_tgw_multi_node.data.aws_instance.ce_master: Read complete after 2s [id=i-016771b511c0c2d1b]
module.aws_tgw_multi_node.volterra_aws_tgw_site.tgw: Refreshing state... [id=c0bada73-60ea-4dfb-b803-4d7c05d3a147]
module.aws_tgw_multi_node.volterra_tf_params_action.aws_tgw_action: Refreshing state... [id=f96dbc25-3581-4e48-9d64-db2ca3cd4c1c]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

## New TGW new subnet module usage example

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "02"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

module "aws_tgw_multi_node_new_subnets" {
  source                          = "./modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file               = var.f5xc_api_p12_file
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_default_ce_sw_version  = true
  f5xc_aws_default_ce_os_version  = true
  f5xc_aws_tgw_name               = format("%s-tgw-multi-node-new-subnets-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_tgw_no_worker_nodes    = false
  f5xc_aws_tgw_total_worker_nodes = 2
  f5xc_aws_tgw_primary_ipv4       = "192.168.168.0/21"
  f5xc_aws_tgw_az_nodes           = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/26", f5xc_aws_tgw_inside_subnet = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node1 : {
      f5xc_aws_tgw_workload_subnet = "192.168.169.0/26", f5xc_aws_tgw_inside_subnet = "192.168.169.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.169.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node2 : {
      f5xc_aws_tgw_workload_subnet = "192.168.170.0/26", f5xc_aws_tgw_inside_subnet = "192.168.170.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.170.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    }
  }
  f5xc_aws_tgw_vpc_attach_label_deploy = "vpc_attachment_label"
  custom_tags                          = {
    Deployment = "aws-tgw-multi-node-01"
    TTL        = -1
    Owner      = "c.klewar@f5.com"
  }
  public_ssh_key = "ssh-rsa xyz"
}
```
## New TGW existing subnet module usage example

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "02"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

module "aws_tgw_multi_node_existing_subnets" {
  source                          = "./modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file               = var.f5xc_api_p12_file
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_default_ce_sw_version  = true
  f5xc_aws_default_ce_os_version  = true
  f5xc_aws_tgw_name               = format("%s-tgw-multi-node-existing-subnets-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_tgw_no_worker_nodes    = false
  f5xc_aws_tgw_total_worker_nodes = 2
  f5xc_aws_vpc_id                 = "vpc_id_abc"
  f5xc_aws_tgw_az_nodes           = {
    node0 : {
      f5xc_aws_tgw_workload_existing_subnet_id = "node0_subnet_workload_id",
      f5xc_aws_tgw_inside_existing_subnet_id   = "node0_subnet_inside_id",
      f5xc_aws_tgw_outside_existing_subnet_id  = "node0_subnet_outside_id"
    },
    node1 : {
      f5xc_aws_tgw_workload_existing_subnet_id = "node1_subnet_workload_id",
      f5xc_aws_tgw_inside_existing_subnet_id   = "node1_subnet_inside_id",
      f5xc_aws_tgw_outside_existing_subnet_id  = "node1_subnet_outside_id"
    },
    node2 : {
      f5xc_aws_tgw_workload_existing_subnet_id = "node2_subnet_workload_id",
      f5xc_aws_tgw_inside_existing_subnet_id   = "node2_subnet_inside_id",
      f5xc_aws_tgw_outside_existing_subnet_id  = "node2_subnet_outside_id"
    }
  }
  f5xc_aws_tgw_vpc_attach_label_deploy = "vpc_attachment_label"
  custom_tags                          = {
    Deployment = "aws-tgw-multi-node-01"
    TTL        = -1
    Owner      = "c.klewar@f5.com"
  }
  public_ssh_key = "ssh-rsa xyz"
}
```

## Existing TGW new subnet module usage example

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "02"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

module "aws_tgw_multi_node_existing_tgw_new_subnets" {
  source                          = "./modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file               = var.f5xc_api_p12_file
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_default_ce_sw_version  = true
  f5xc_aws_default_ce_os_version  = true
  f5xc_aws_tgw_name               = format("%s-tgw-multi-node-new-subnets-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_tgw_no_worker_nodes    = false
  f5xc_aws_tgw_total_worker_nodes = 2
  f5xc_aws_tgw_primary_ipv4       = "192.168.168.0/21"
  f5xc_aws_tgw_id                 = "tgw_id_abc"
  f5xc_aws_tgw_asn                = 63200
  f5xc_aws_tgw_site_asn           = 65400
  f5xc_aws_tgw_az_nodes           = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/26", f5xc_aws_tgw_inside_subnet = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node1 : {
      f5xc_aws_tgw_workload_subnet = "192.168.169.0/26", f5xc_aws_tgw_inside_subnet = "192.168.169.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.169.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node2 : {
      f5xc_aws_tgw_workload_subnet = "192.168.170.0/26", f5xc_aws_tgw_inside_subnet = "192.168.170.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.170.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    }
  }
  f5xc_aws_tgw_vpc_attach_label_deploy = "vpc_attachment_label"
  custom_tags                          = {
    Deployment = "aws-tgw-multi-node-01"
    TTL        = -1
    Owner      = "c.klewar@f5.com"
  }
  public_ssh_key = "ssh-rsa xyz"
}

```

## Existing TGW existing subnet module usage example

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "02"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

module "aws_tgw_multi_node_existing_tgw_existing_subnets" {
  source                          = "./modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file               = var.f5xc_api_p12_file
  f5xc_api_url                    = var.f5xc_api_url
  f5xc_namespace                  = "system"
  f5xc_tenant                     = var.f5xc_tenant
  f5xc_aws_region                 = "us-east-2"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_default_ce_sw_version  = true
  f5xc_aws_default_ce_os_version  = true
  f5xc_aws_tgw_name               = format("%s-tgw-multi-node-existing-tgw-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_tgw_no_worker_nodes    = false
  f5xc_aws_tgw_total_worker_nodes = 2
  f5xc_aws_vpc_id                 = "vpc_id_abc"
  f5xc_aws_tgw_id                 = "tgw_id_abc"
  f5xc_aws_tgw_asn                = 63200
  f5xc_aws_tgw_site_asn           = 65400
  f5xc_aws_tgw_az_nodes           = {
    node0 : {
      f5xc_aws_tgw_workload_existing_subnet_id = "node0_subnet_workload_id",
      f5xc_aws_tgw_inside_existing_subnet_id   = "node0_subnet_inside_id",
      f5xc_aws_tgw_outside_existing_subnet_id  = "node0_subnet_outside_id"
    },
    node1 : {
      f5xc_aws_tgw_workload_existing_subnet_id = "node1_subnet_workload_id",
      f5xc_aws_tgw_inside_existing_subnet_id   = "node1_subnet_inside_id",
      f5xc_aws_tgw_outside_existing_subnet_id  = "node1_subnet_outside_id"
    },
    node2 : {
      f5xc_aws_tgw_workload_existing_subnet_id = "node2_subnet_workload_id",
      f5xc_aws_tgw_inside_existing_subnet_id   = "node2_subnet_inside_id",
      f5xc_aws_tgw_outside_existing_subnet_id  = "node2_subnet_outside_id"
    }
  }
  f5xc_aws_tgw_vpc_attach_label_deploy = "vpc_attachment_label"
  custom_tags                          = {
    Deployment = "aws-tgw-multi-node-01"
    TTL        = -1
    Owner      = "c.klewar@f5.com"
  }
  public_ssh_key = "ssh-rsa xyz"
}
```

## New TGW new subnet module and direct connect usage example

```hcl
variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "02"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

module "aws_tgw_multi_node_new_tgw_new_subnets_direct_connect" {
  source                                    = "./modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file                         = var.f5xc_api_p12_file
  f5xc_api_url                              = var.f5xc_api_url
  f5xc_namespace                            = "system"
  f5xc_tenant                               = var.f5xc_tenant
  f5xc_aws_region                           = "us-east-2"
  f5xc_aws_cred                             = "aws-01"
  f5xc_aws_default_ce_sw_version            = true
  f5xc_aws_default_ce_os_version            = true
  f5xc_aws_tgw_name                         = format("%s-tgw-multi-node-new-tgw-direct-connect-%s", var.project_prefix, var.project_suffix)
  f5xc_aws_tgw_no_worker_nodes              = false
  f5xc_aws_tgw_total_worker_nodes           = 2
  f5xc_aws_tgw_primary_ipv4                 = "192.168.168.0/21"
  f5xc_aws_tgw_direct_connect_disabled      = false
  f5xc_aws_tgw_cloud_aggregated_prefix      = ["10.15.250.0/21"]
  f5xc_aws_tgw_dc_connect_aggregated_prefix = ["10.16.250.0/21"]
  f5xc_aws_tgw_manual_gw                    = true
  f5xc_aws_tgw_az_nodes                     = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/26", f5xc_aws_tgw_inside_subnet = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node1 : {
      f5xc_aws_tgw_workload_subnet = "192.168.169.0/26", f5xc_aws_tgw_inside_subnet = "192.168.169.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.169.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node2 : {
      f5xc_aws_tgw_workload_subnet = "192.168.170.0/26", f5xc_aws_tgw_inside_subnet = "192.168.170.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.170.128/26", f5xc_aws_tgw_az_name = "us-east-2a"
    }
  }
  f5xc_aws_tgw_vpc_attach_label_deploy = "vpc_attachment_label"
  custom_tags                          = {
    Deployment = "aws-tgw-multi-node-01"
    TTL        = -1
    Owner      = "c.klewar@f5.com"
  }
  public_ssh_key = "ssh-rsa xyz"
}
```

