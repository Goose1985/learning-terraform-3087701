data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y java-17-amazon-corretto-headless
              curl -fsSL https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz -o /tmp/tomcat.tar.gz
              mkdir -p /opt/tomcat
              tar xzf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1
              /opt/tomcat/bin/startup.sh
              EOF

  tags = {
    Name = "HelloWorld"
  }
}
