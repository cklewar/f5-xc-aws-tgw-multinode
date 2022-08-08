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

## Multi NIC module usage example

```hcl
module "aws_tgw_multi_node" {
  source                          = "./modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file               = "cert/api-creds.p12"
  f5xc_api_url                    = "https://playground.staging.volterra.us/api"
  f5xc_namespace                  = "system"
  f5xc_tenant                     = "playground"
  f5xc_aws_cred                   = "aws-01"
  f5xc_aws_default_ce_sw_version  = true
  f5xc_aws_default_ce_os_version  = true
  f5xc_aws_tgw_az_name            = "us-east-2a"
  f5xc_aws_tgw_name               = "aws-tgw-multi-node-01"
  f5xc_aws_tgw_no_worker_nodes    = false
  f5xc_aws_tgw_total_worker_nodes = 2
  f5xc_aws_tgw_primary_ipv4       = "172.16.32.0/21"
  f5xc_aws_tgw_az_nodes           = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "172.16.32.0/25", f5xc_aws_tgw_inside_subnet = "172.16.32.128/25",
      f5xc_aws_tgw_outside_subnet  = "172.16.33.0/25", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node1 : {
      f5xc_aws_tgw_workload_subnet = "172.16.34.0/25", f5xc_aws_tgw_inside_subnet = "172.16.34.128/25",
      f5xc_aws_tgw_outside_subnet  = "172.16.35.0/25", f5xc_aws_tgw_az_name = "us-east-2a"
    },
    node2 : {
      f5xc_aws_tgw_workload_subnet = "172.16.36.0/25", f5xc_aws_tgw_inside_subnet = "172.16.36.128/25",
      f5xc_aws_tgw_outside_subnet  = "172.16.37.0/25", f5xc_aws_tgw_az_name = "us-east-2a"
    }
  }
  f5xc_aws_tgw_vpc_attach_label_deploy = ""
  aws_owner_tag                        = "c.klewar@f5.com"
  public_ssh_key                       = "ssh-rsa xyz"
}
```