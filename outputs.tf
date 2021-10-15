output "Loadbalancer"{
    description = "DNS Load Balancer"
    value = aws_lb.loadBalancer.dns_name
}
output "rds_hostname"{
    description = "RDS instance root user"
    value = aws_db_instance.djlbanco.address
}
