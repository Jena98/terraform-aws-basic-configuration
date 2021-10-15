# Create a S3 Bucket
/*
resource "aws_s3_bucket" "jj-testbucket" {
  bucket = "jj-testbucket"
  acl    = "private"

  tags = {
    Name        = "jj-bucket"
    Environment = "Dev"
  }
}*/

# Create a Security Group
resource "aws_security_group" "Jena-Public-SG" {
  name        = "Jena-Public-SG"
  description = "Jena-Public-SG"
  vpc_id      = aws_vpc.jena-iac-vpc.id

  ingress {
      description      = "http"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jena-Public-SG"
  }
}

# Create a ALB
resource "aws_lb" "jj-alb" {
  name               = "jj-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Jena-Public-SG.id]
  subnets            = [aws_subnet.jena-Public-SN-1.id, aws_subnet.jena-Public-SN-2.id]

  enable_deletion_protection = true

  tags = {
    Name = "jj-alb"
  }
}


# Create a Target Group
resource "aws_lb_target_group" "jj-tg" {
  name     = "jj-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.jena-iac-vpc.id
}

# Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.jj-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jj-tg.arn
  }
}