<<<<<<< HEAD




provider "aws" {
  region = var.region
}




#creating the key pair

resource "aws_key_pair" "cali-key" {
  key_name   = "cali-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnIAUN2VGyu2Xp3RCs4L5cJ3KozRpeEcS2mBb5mwtChYmnnwvZEDJ57jliskwGF0LlJdRbjBKDEQqKLzVeiCPtJqXdXCwoDp+9SISHeQr3vruW1uqOu/dQwdgPsL4YSqnOvnVG8h5UPeEJ3kV2utx/9Xp+ZorgxTQNlPhqtedZa/ifruyS/s67e7UW4KbxNfbMZeypBZ2peuKiTdHc2hXT5EZcLLohTe+jpnnP93M9EAdYjN5wpDPoce7GcYFU6IGUz+DCb2Ib8Ekq1axnRnSSU2x84dk8SpwNecx7rA/HzsQdMKLd0IHw/lOxejsx0Uq5/IF9zBy6rZMruZFW6IdRwa6mFjXHPkgHoyanrj7rhu5EtYIF+YZ6/4jACJwHUJTjlzQCQqGVhxxpmXJsGLMGdxZ36viQaorfwWtXJtwbypH6Q2xTOcWGKshMSrhub/ZrNmPRnw+caF7LRljQdkBtsna5lw/eeal0k/2cJglLGiFvDf1Gxe4Gzn69oP9neh8= inquilab@DESKTOP-PJ1QRT1"
}
#creating security group

resource "aws_security_group" "cali_security_group" {
  name        = "cali_security_group"
  description = "Allow 80 and 22 port as inbound"
  vpc_id      = aws_vpc.cali-vpc.id

  ingress {
    description = "22 from outside"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.221.75.221/32", "0.0.0.0/0"]
  }

  ingress {
    description = "80 from outside"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_80_22"
  }
}

#creating the internet gateway

resource "aws_internet_gateway" "cali_IGW" {
  vpc_id = aws_vpc.cali-vpc.id

  tags = {
    Name = "Mumbai_IGW"
  }
}

#create route table

resource "aws_route_table" "cali_public_RT" {
  vpc_id = aws_vpc.cali-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cali_IGW.id
  }

  tags = {
    Name = "cali_public_RT"
  }
}

resource "aws_route_table_association" "subnet_2a_association" {
  subnet_id      = aws_subnet.cali-subnet-2a.id
  route_table_id = aws_route_table.cali_public_RT.id
}

resource "aws_route_table_association" "subnet_2b_association" {
  subnet_id      = aws_subnet.cali-subnet-2b.id
  route_table_id = aws_route_table.cali_public_RT.id
}




#create Load balancer

resource "aws_lb" "cali_lb" {
  name               = "cali-webapp"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cali_security_group.id]
  subnets            = [aws_subnet.cali-subnet-2a.id, aws_subnet.cali-subnet-2b.id]

  #enable_deletion_protection = true/false

  tags = {
    Environment = "production"
  }
}


#create listerner

resource "aws_lb_listener" "cali-listener" {
  load_balancer_arn = aws_lb.cali_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cali-TG.arn
  }
}

#target group

resource "aws_lb_target_group" "cali-TG" {
  name     = "cali-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cali-vpc.id
}



#creating the launch template
resource "aws_launch_template" "cali_launch_template" {
  name      = "cali_launch_template"
  image_id  = "ami-008fe2fc65df48dac"
  key_name  = aws_key_pair.cali-key.id
  vpc_security_group_ids = [aws_security_group.cali_security_group.id]
  instance_type = "t2.micro"
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "cali-Instance-via-ASG"
    }
  }

  user_data = filebase64("example.sh")

}

#create auto scaling group

resource "aws_autoscaling_group" "cali_asg" {
  name = "cali_ASG"  
  vpc_zone_identifier = [aws_subnet.cali-subnet-2a.id, aws_subnet.cali-subnet-2b.id]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 2
  target_group_arns = [aws_lb_target_group.cali-TG.arn]

  launch_template {
    id      = aws_launch_template.cali_launch_template.id
    version = "$Latest"
  }
}

=======




provider "aws" {
  region = var.region
}




#creating the key pair

resource "aws_key_pair" "cali-key" {
  key_name   = "cali-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDnIAUN2VGyu2Xp3RCs4L5cJ3KozRpeEcS2mBb5mwtChYmnnwvZEDJ57jliskwGF0LlJdRbjBKDEQqKLzVeiCPtJqXdXCwoDp+9SISHeQr3vruW1uqOu/dQwdgPsL4YSqnOvnVG8h5UPeEJ3kV2utx/9Xp+ZorgxTQNlPhqtedZa/ifruyS/s67e7UW4KbxNfbMZeypBZ2peuKiTdHc2hXT5EZcLLohTe+jpnnP93M9EAdYjN5wpDPoce7GcYFU6IGUz+DCb2Ib8Ekq1axnRnSSU2x84dk8SpwNecx7rA/HzsQdMKLd0IHw/lOxejsx0Uq5/IF9zBy6rZMruZFW6IdRwa6mFjXHPkgHoyanrj7rhu5EtYIF+YZ6/4jACJwHUJTjlzQCQqGVhxxpmXJsGLMGdxZ36viQaorfwWtXJtwbypH6Q2xTOcWGKshMSrhub/ZrNmPRnw+caF7LRljQdkBtsna5lw/eeal0k/2cJglLGiFvDf1Gxe4Gzn69oP9neh8= inquilab@DESKTOP-PJ1QRT1"
}
#creating security group

resource "aws_security_group" "cali_security_group" {
  name        = "cali_security_group"
  description = "Allow 80 and 22 port as inbound"
  vpc_id      = aws_vpc.cali-vpc.id

  ingress {
    description = "22 from outside"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.221.75.221/32", "0.0.0.0/0"]
  }

  ingress {
    description = "80 from outside"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_80_22"
  }
}

#creating the internet gateway

resource "aws_internet_gateway" "cali_IGW" {
  vpc_id = aws_vpc.cali-vpc.id

  tags = {
    Name = "Mumbai_IGW"
  }
}

#create route table

resource "aws_route_table" "cali_public_RT" {
  vpc_id = aws_vpc.cali-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cali_IGW.id
  }

  tags = {
    Name = "cali_public_RT"
  }
}

resource "aws_route_table_association" "subnet_2a_association" {
  subnet_id      = aws_subnet.cali-subnet-2a.id
  route_table_id = aws_route_table.cali_public_RT.id
}

resource "aws_route_table_association" "subnet_2b_association" {
  subnet_id      = aws_subnet.cali-subnet-2b.id
  route_table_id = aws_route_table.cali_public_RT.id
}




#create Load balancer

resource "aws_lb" "cali_lb" {
  name               = "cali-webapp"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cali_security_group.id]
  subnets            = [aws_subnet.cali-subnet-2a.id, aws_subnet.cali-subnet-2b.id]

  #enable_deletion_protection = true/false

  tags = {
    Environment = "production"
  }
}


#create listerner

resource "aws_lb_listener" "cali-listener" {
  load_balancer_arn = aws_lb.cali_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cali-TG.arn
  }
}

#target group

resource "aws_lb_target_group" "cali-TG" {
  name     = "cali-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cali-vpc.id
}



#creating the launch template
resource "aws_launch_template" "cali_launch_template" {
  name      = "cali_launch_template"
  image_id  = "ami-008fe2fc65df48dac"
  key_name  = aws_key_pair.cali-key.id
  vpc_security_group_ids = [aws_security_group.cali_security_group.id]
  instance_type = "t2.micro"
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "cali-Instance-via-ASG"
    }
  }

  user_data = filebase64("example.sh")

}

#create auto scaling group

resource "aws_autoscaling_group" "cali_asg" {
  name = "cali_ASG"  
  vpc_zone_identifier = [aws_subnet.cali-subnet-2a.id, aws_subnet.cali-subnet-2b.id]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 2
  target_group_arns = [aws_lb_target_group.cali-TG.arn]

  launch_template {
    id      = aws_launch_template.cali_launch_template.id
    version = "$Latest"
  }
}

>>>>>>> 0ca5a3d (Initial commit)
