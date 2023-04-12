#INSTANCES
resource "aws_instance" "Jenkins_Master" {
  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = false
  }
  availability_zone = "us-east-1a"
  ami           = "ami-0113ab34450e56f0a"
  instance_type = "t3.micro"
  subnet_id   = aws_subnet.public_subnet[0].id
  security_groups = [aws_security_group.jenkins_alb_sg.id]

  tags = {
    Name = "Jenkins_Master"
    Environment = "mid project"
  }
}

resource "aws_instance" "Jenkins_Slave" {
  root_block_device {
    volume_size           = "10"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = false
  }
  availability_zone = "us-east-1a"
  ami           = "ami-0672d44d0593d0357"
  instance_type = "t3.micro"
  subnet_id   = aws_subnet.public_subnet[0].id
  security_groups = [aws_security_group.jenkins_alb_sg.id]

  tags = {
    Name = "Jenkins_Slave"
    Environment = "mid project"
  }
}