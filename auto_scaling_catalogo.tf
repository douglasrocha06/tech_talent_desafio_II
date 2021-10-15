#=========================launch_configuration catalogo===================================================
resource "aws_launch_configuration" "djl_lauch_config_catalogo" {
  name                      = "djl_lauch_config_catalogo"
  image_id                  = "ami-02eff6d4a1d471125"
  instance_type             = "t2.micro"
  key_name                  = "douglas-acesso"
  security_groups           = [aws_security_group.sg_ssh_djl.id, aws_security_group.sg_lb_djl.id]
  user_data                 = file("arq_catalogo.sh")

  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
      volume_size = 8
      delete_on_termination = true
    }
}
#=========================Auto Scaling Catalogo===================================================
resource "aws_autoscaling_group" "djl_AS_catalogo" {
  name                 = "djl_AutoScaling_catalogo"
  launch_configuration = aws_launch_configuration.djl_lauch_config_catalogo.name
  vpc_zone_identifier = [aws_subnet.privateapp_djl_1a.id, aws_subnet.privateapp_djl_1c.id]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  target_group_arns         = [aws_lb_target_group.lb_tg_djl_catalogo.arn]
  tag {
    key = "Name"
    value = "djl_AutoScaling_catalogo"
    propagate_at_launch = true
  }
  depends_on = [aws_db_instance.djlbanco,aws_db_subnet_group.djl_dbgroup,aws_instance.bastion_host_djl]
}
resource "aws_autoscaling_attachment" "asg_attachment_djl_catalogo" {
  autoscaling_group_name = aws_autoscaling_group.djl_AS_catalogo.id
  alb_target_group_arn   = aws_lb_target_group.lb_tg_djl_catalogo.arn
  depends_on = [aws_db_instance.djlbanco,aws_db_subnet_group.djl_dbgroup,aws_instance.bastion_host_djl]
}

#===================== Target Catalogo======================
resource "aws_lb_target_group" "lb_tg_djl_catalogo" {
  name        = "lb-tg-djl-catalogo"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_djl.id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 10
    timeout             = 5
    #port                = 80
    interval            = 300
    matcher = "200-401"
  }
}
#====================================================Políticas de Escalonamento================================================
resource "aws_autoscaling_policy" "autopolicy-up-catalogo" {
  name                   = "autopolicy-up-catalogo"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.djl_AS_catalogo.name
}

#Se a média de processamento do Auto Scaling Group ficar acima de 60% durante 2 checagens com intervalo de 2 minutos. Sobe a EC2.
resource "aws_cloudwatch_metric_alarm" "alarm-up-catalogo" {
    alarm_name = "alarm-djl-catalogo"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "60"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.djl_AS_catalogo.name
    }

    alarm_description = "Monitoramento da utilização da CPU"
    alarm_actions = [aws_autoscaling_policy.autopolicy-up-catalogo.arn]
}

#Se a média de processamento do Auto Scaling Group ficar abaixo de 20% durante 2 checagens com intervalo de 2 minutos. Desce as EC2.
resource "aws_autoscaling_policy" "autopolicy-down-catalogo" {
    name = "autopolicy-down-catalogo"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.djl_AS_catalogo.name
}

resource "aws_cloudwatch_metric_alarm" "alarm-down-catalogo" {
    alarm_name = "alarm-down-catalogo"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "10"

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.djl_AS_catalogo.name
    }

    alarm_description = "Monitoramento da utilização da CPU"
    alarm_actions = [aws_autoscaling_policy.autopolicy-down-catalogo.arn]
}
