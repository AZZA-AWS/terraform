module "_shared_vars" {
  source = "../_shared_vars"

}

variable "public_sg_id" {

}

// alb
resource "aws_lb" "sample_app_alb" {
  name               = "sample-app-alb-${module._shared_vars.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.public_sg_id}"]
  subnets            = ["${module._shared_vars.pub_sub_id1}", "${module._shared_vars.pub_sub_id2}"]

  # enable_deletion_protection = true

  tags = {
    Environment = "${module._shared_vars.env_suffix}"
  }
}

// target group

resource "aws_lb_target_group" "sample-app-tg" {
  name     = "sample-app-tg-${module._shared_vars.env_suffix}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module._shared_vars.vpc_id
}

// listener
resource "aws_lb_listener" "http_listener_80" {
  load_balancer_arn = aws_lb.sample_app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  #   ssl_policy        = "ELBSecurityPolicy-2016-08"
  #   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample-app-tg.arn
  }
}


output "tg_arn" {
  value = aws_lb_target_group.sample-app-tg.arn
}
