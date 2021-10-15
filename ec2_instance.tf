#Acesso bastion host
resource "aws_instance" "bastion_host_djl" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_djl_1a.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.public-sec-djl.id]
  availability_zone = "us-east-1a"
  key_name = "douglas-acesso"
 
 connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/douglasrocha06/.ssh/douglas-acesso")
    host        = self.public_dns
  }
  provisioner "file" {
    source      = "/home/douglasrocha06/.ssh/douglas-acesso"
    destination = "/home/ubuntu/douglas-acesso"
  }
  provisioner "file" {
    source      = "/home/douglasrocha06/terraform/script.sql"
    destination = "/home/ubuntu/script.sql"
  }
  provisioner "remote-exec"{
      inline = [
        "sudo apt-get update",
        "chmod 700 douglas-acesso",
        "sudo apt install mysql-client-core-8.0",
        "mysql -h djlbanco.cxycaymkd24m.us-east-1.rds.amazonaws.com -P 3306 -u admin -p12345678 < script.sql"
      ]
  }
  tags = {
    Name = "bastion_host_djl"
  }
  depends_on = [aws_db_instance.djlbanco]
  root_block_device {
      volume_size = 8
      delete_on_termination = true
    }
}

