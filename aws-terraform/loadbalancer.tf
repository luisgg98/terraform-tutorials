
##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

# Our app listens on port 8080 using the plain HTTP protocol.
# You need to provide a VPC id, and optionally you can configure slow_start if your application needs time to warm up. The default value is 0.
# Then you can select the algorithm type; the default is round_robin, but you can also choose least_outstanding_requests.
# There is also an optional block for stickiness if you need it; I will disable it for now.
# The health check block is very important. If the health check on the EC2 instance fails, the load balancer removes it from the pool. First, you need to enable it. Then specify port 8081 for the health check. The protocol is HTTP and /health endpoint. You can customize the status code. To indicate that the instance is healthy, I send a 200 status code.
resource "aws_lb_target_group" "load_balancer_tg" {
  name       = var.load_balancer_tg
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc_main.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

}

# To manually register EC2 instances to the target group, you need to iterate
# over each virtual machine and attach it to the group using the traffic 8080 port.

resource "aws_lb_target_group_attachment" "ld_tg_attach" {
  for_each         = { for idx, instance in aws_instance.nodejs_instances : idx => instance }
  target_group_arn = aws_lb_target_group.load_balancer_tg.arn
  target_id        = each.value.id
  port             = 80
}
#Indicates that the load balancer needs to be associated with at least two subnets that are in different Availability Zones. This is a requirement for AWS application load balancers to ensure high availability and fault tolerance.
resource "aws_lb" "aws_lb_main" {
  name               = var.load_balancer_rc
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_loadbalancer.id]

  subnets = [aws_subnet.public_loadbalancer_subnet.id, aws_subnet.additional_loadbalancer_subnet.id]
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.aws_lb_main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load_balancer_tg.arn
  }
}

output "load_balancer_public_ip" {
  value = aws_lb.aws_lb_main.dns_name
}