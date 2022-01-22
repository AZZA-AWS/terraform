locals {
  env = terraform.workspace

  vpcid_env = {
    default = "dev_vpc"
    staging = "vpc-7e501116"
    prod    = "vpc-7e501116"
  }
  vpc_id = lookup(local.vpcid_env, local.env)

  pub_sub_env1 = {
    default = "dev_subnet"
    staging = "subnet-4355262b"
    prod    = "subnet-4355262b"
  }
  pub_sub_id1 = lookup(local.pub_sub_env1, local.env)

  pub_sub_env2 = {
    default = "dev_subnet"
    staging = "subnet-59322e14"
    prod    = "subnet-59322e14"
  }
  pub_sub_id2 = lookup(local.pub_sub_env2, local.env)

  prv_sub_env = {
    default = "dev_subnet"
    staging = "subnet-c1a50dbb"
    prod    = "subnet-c1a50dbb"
  }
  prv_sub_id = lookup(local.prv_sub_env, local.env)
}



output "env_suffix" {
  value = local.env
}

output "vpc_id" {
  value = local.vpc_id
}

output "pub_sub_id1" {
  value = local.pub_sub_id1
}


output "pub_sub_id2" {
  value = local.pub_sub_id2
}

output "prv_sub_id" {
  value = local.prv_sub_id
}

