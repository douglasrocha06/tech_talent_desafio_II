#=========================Load Balancer=================================
resource "aws_lb" "loadBalancer" {
  name               = "loadBalancer-djl"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_lb_djl.id]
  subnets            = [aws_subnet.public_djl_1a.id, aws_subnet.public_djl_1c.id]

  tags = {
    Name = "loadBalancer-djl"
  }
}
#==========================Listener======================================
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_db_instance.djlbanco, 
                      aws_db_subnet_group.djl_dbgroup,
                      aws_instance.bastion_host_djl,
                      aws_lb_target_group.lb_tg_djl,
                      aws_lb_target_group.lb_tg_djl_enderecos,
                      aws_lb_target_group.lb_tg_djl_catalogo,
                      aws_lb_target_group.lb_tg_djl_inventario
                      ]
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/html"
      message_body = "Página não encontrada."
      status_code  = 200
    }
  }
}
#===========================Clientes all=================================
resource "aws_lb_listener_rule" "listener_rule_all" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl.arn
  }

  condition {
    path_pattern {
      values = ["/clientes/*"]
    }
  }
}

#===========================Clientes ===============================
resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl.arn
  }

  condition {
    path_pattern {
      values = ["/clientes"]
    }
  }
}
#===========================Endereços all===============================
resource "aws_lb_listener_rule" "listener_rule_enderecos_all" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl_enderecos.arn
  }

  condition {
    path_pattern {
      values = ["/enderecos/*"]
    }
  }
}
#===========================Endereços===============================
resource "aws_lb_listener_rule" "listener_rule_enderecos" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 97

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl_enderecos.arn
  }

  condition {
    path_pattern {
      values = ["/enderecos"]
    }
  }
}
#===========================Catalogo all===============================
resource "aws_lb_listener_rule" "listener_rule_catalogo_all"{
  listener_arn = aws_lb_listener.lb-listener.arn
  priority = 96

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl_catalogo.arn
  }

  condition {
    path_pattern {
      values = ["/catalogo/*"]
    }
  }
}
#===========================Catalogo===============================
resource "aws_lb_listener_rule" "listener_rule_catalogo"{
  listener_arn = aws_lb_listener.lb-listener.arn
  priority = 95

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl_catalogo.arn
  }

  condition {
    path_pattern {
      values = ["/catalogo"]
    }
  }
}
#===========================Inventario all===============================
resource "aws_lb_listener_rule" "listener_rule_inventario_all"{
  listener_arn = aws_lb_listener.lb-listener.arn
  priority = 94

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl_inventario.arn
  }

  condition {
    path_pattern {
      values = ["/compras/*"]
    }
  }
}

#===========================Inventario===============================
resource "aws_lb_listener_rule" "listener_rule_inventario"{
  listener_arn = aws_lb_listener.lb-listener.arn
  priority = 93

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_djl_inventario.arn
  }

  condition {
    path_pattern {
      values = ["/compras"]
    }
  }
}