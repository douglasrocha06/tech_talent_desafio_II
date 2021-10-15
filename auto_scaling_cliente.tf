#=========================launch_configuration cliente=========================================
resource "aws_launch_configuration" "djl_lauch_config" {
  name                      = "djl_lauch_config_cliente"
  image_id                  = "ami-00779a35681b39603"
  instance_type             = "t2.micro"
  key_name                  = "douglas-acesso"
  security_groups           = [aws_security_group.sg_ssh_djl.id, aws_security_group.sg_lb_djl.id]
  user_data                 = file("arq_clientes.sh")

  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
      volume_size = 8
      delete_on_termination = true
    }
}
#=========================Auto Scaling cliente===================================================
resource "aws_autoscaling_group" "djl_AS" {
  name                      = "djl_AutoScaling_clientes"
  launch_configuration      = aws_launch_configuration.djl_lauch_config.name
  vpc_zone_identifier       = [aws_subnet.privateapp_djl_1a.id, aws_subnet.privateapp_djl_1c.id]
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.lb_tg_djl.arn]
  tag {
    key                     = "Name"
    value                   = "djl_AutoScaling_clientes"
    propagate_at_launch     = true
  }
  depends_on = [aws_db_instance.djlbanco, aws_db_subnet_group.djl_dbgroup, aws_instance.bastion_host_djl]
}
resource "aws_autoscaling_attachment" "asg_attachment_djl" {
  autoscaling_group_name    = aws_autoscaling_group.djl_AS.id
  alb_target_group_arn      = aws_lb_target_group.lb_tg_djl.arn
  depends_on                = [aws_db_instance.djlbanco, aws_db_subnet_group.djl_dbgroup, aws_instance.bastion_host_djl]
}
#===================== Target Group Clientes======================
resource "aws_lb_target_group" "lb_tg_djl" {
  name                      = "lb-tg-djl"
  port                      = 80
  protocol                  = "HTTP"
  target_type               = "instance"
  vpc_id                    = aws_vpc.vpc_djl.id

  health_check {
    healthy_threshold       = 5
    unhealthy_threshold     = 10
    timeout                 = 5
    interval                = 300
    #port                    = 80
    matcher                 = "200-401"
  }
}

#===================================Políticas de Escalonamento Cliente==============================================
resource "aws_autoscaling_policy" "autopolicy-up" {
  name                      = "autopolicy-up"
  scaling_adjustment        = 1
  adjustment_type           = "ChangeInCapacity"
  cooldown                  = 300
  autoscaling_group_name    = aws_autoscaling_group.djl_AS.name
  depends_on                = [aws_db_instance.djlbanco, aws_db_subnet_group.djl_dbgroup, aws_instance.bastion_host_djl]
}

#Se a média de processamento do Auto Scaling Group ficar acima de 60% durante 2 checagens com intervalo de 2 minutos. Sobe a EC2.
resource "aws_cloudwatch_metric_alarm" "alarm-up" {
  alarm_name                = "alarm-djl"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.djl_AS.name
  }

  alarm_description         = "Monitoramento da utilização da CPU"
  alarm_actions             = [aws_autoscaling_policy.autopolicy-up.arn]
}

#Se a média de processamento do Auto Scaling Group ficar abaixo de 20% durante 2 checagens com intervalo de 2 minutos. Desce as EC2.
resource "aws_autoscaling_policy" "autopolicy-down" {
  name                      = "autopolicy-down"
  scaling_adjustment        = -1
  adjustment_type           = "ChangeInCapacity"
  cooldown                  = 300
  autoscaling_group_name    = aws_autoscaling_group.djl_AS.name
}

resource "aws_cloudwatch_metric_alarm" "alarm-down" {
  alarm_name                = "alarm-down"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.djl_AS.name
  }

  alarm_description         = "Monitoramento da utilização da CPU"
  alarm_actions             = [aws_autoscaling_policy.autopolicy-down.arn]
}

