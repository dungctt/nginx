# Build a simple EC2 in custom VPC
- In this assignment, I will build an EC2 which runs docker inside. The environment diagram is below
https://github.com/dungctt/nginx/blob/main/assingment.png

## Step-01: Create VPC
- Create VPC using `Terraform Modules`
- Define `local values` and reference them in VPC Terraform Module
- Create `terraform.tfvars` to load variable values by default from this file
- Create `input_value.tfvars` to load variable values from this file related to a VPC 
- Define `Output Values` for VPC
- Define `variables.tf` which can be reused 
- Create VPC in `vpc-module.tf` 
- [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)


## Step-02: Create EC2 and associate to VPC
- Create EC2 with newest ami linux version which defined in `ami-datasource.tf`
- Define provider, user profile and version constrain in `provider.tf`
- Define variables will be used in `main.tf`
- Create script file which will be used to get the docker status every 10s in `script.sh`
- Define outputs which will show in the screen after running terraform apply
- Create EC2 instance in file `main.tf`
- Create security group uses resource `aws_security_group`

## Step-03: Pull docker image and run NGinx inside docker, output the docker status in file stats.txt
- Ansible playbook is in file `provision.ylm`
- Ansible playbook uses ansible.builtin.yum and shell modules to install docker and run nginx

## Step-04: Execute Terraform Commands
```t
# Working Folder
Nginx

# Terraform Initialize
terraform init
Observation:
1. Verify if modules got downloaded to .terraform folder

# Terraform Validate
terraform validate

# Terraform plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
Observation:
1) Verify VPC
2) Verify Subnets
3) Verify EC2
4) Verify Docker
5) Verify Nginx
6) Verify log
7) Verify Tags

```
## Step-05: Execute Ansible playbook to setup docker and get the log file.
- Ansible workspace ./ansible/
- Modify the /etc/ansible/hosts file with EC2 IP address
- Ansible config file is in /etc/ansible/ansible.cfg
- Run command ansible-playbook provision.yml

## Describe about my deployment
- Things are done:
  + Create VPC, subnet, secuirty group, EC2 by Terraform
  + Install docker, flask, python by Ansible
  + Run docker, get log by Ansible
  + Mount log file to Nginx by Ansible
- Things haven't finished yet: Write a REST API to search in log file.
- We can improve these tasks by setup CI/CD and do automate deploy by CI/CD platform such as gitlab, Jenkin, etc.
