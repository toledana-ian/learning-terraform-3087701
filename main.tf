data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "web_subnet" {
  vpc_id     = aws_vpc.web_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "web_security_group" {
  vpc_id = aws_vpc.web_vpc.id
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.web_subnet.id
  vpc_security_group_ids = [aws_security_group.web_security_group.id]


  tags = {
    Name = "HelloWorld"
  }
}
