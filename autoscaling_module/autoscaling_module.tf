module "_shared_vars" {
  source = "../_shared_vars"

}

variable "public_sg_id" {

}
variable "tg_arn" {

}
locals {
  env = terraform.workspace

  ami_env = {
    default = "dev_ami"
    staging = "ami-001089eb624938d9f"
    prod    = "ami-066157edddaec5e49"

  }
  ami_id = lookup(local.ami_env, local.env)

  instance_type_env = {
    default = "dev_instance_type"
    staging = "t2.nano"
    prod    = "t2.micro"
  }
  instance_type = lookup(local.instance_type_env, local.env)

  keypair_env = {
    default = "dev_keypair"
    staging = "tf_key_staging"
    prod    = "tf_key_prod"
  }

  keypair_name = lookup(local.keypair_env, local.env)

  asg_min_env = {
    default = 1
    staging = 1
    prod    = 1
  }

  asg_min_count = lookup(local.asg_min_env, local.env)

  asg_max_env = {
    default = 1
    staging = 1
    prod    = 1
  }

  asg_max_count = lookup(local.asg_max_env, local.env)


  asg_desired_env = {
    default = 1
    staging = 1
    prod    = 1
  }

  asg_desired_count = lookup(local.asg_desired_env, local.env)


}


// ASG launch config
resource "aws_launch_configuration" "sample_app_lc" {
  name            = "sample_app_lc_${module._shared_vars.env_suffix}"
  image_id        = local.ami_id
  instance_type   = local.instance_type
  security_groups = [var.public_sg_id]
  key_name        = local.keypair_name
  user_data       = file("assets/userdata.txt")

}


// autoscaling group

resource "aws_autoscaling_group" "sample_app_asg" {
  name = "sample_app_asg_${module._shared_vars.env_suffix}"

  health_check_grace_period = 300
  health_check_type         = "ELB"
  max_size                  = local.asg_min_count
  min_size                  = local.asg_max_count
  desired_capacity          = local.asg_desired_count
  force_delete              = true
  launch_configuration      = aws_launch_configuration.sample_app_lc.name
  vpc_zone_identifier       = [module._shared_vars.pub_sub_id1, module._shared_vars.pub_sub_id2]
  target_group_arns         = [var.tg_arn]

  tags = [
    {
      key                 = "Name"
      value               = "sample_app_asg_${module._shared_vars.env_suffix}"
      propagate_at_launch = true
    },
    {
      key                 = "env"
      value               = "${module._shared_vars.env_suffix}"
      propagate_at_launch = true
    }
  ]
}
