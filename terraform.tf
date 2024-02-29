provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "Allow all traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "docker-qa-sg" {
  name        = "docker-qa-sg"
  description = "Allow traffic for Docker and QA"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s_master" {
  ami           = "ami-0187337106779cdf8"
  instance_type = "t2.medium"
  key_name      = "jenkins-slave-key"

  vpc_security_group_ids = [aws_security_group.k8s-sg.id]

  tags = {
    Name = "k8s_master"
  }
}

resource "aws_instance" "k8s_node" {
  count         = 3
  ami           = "ami-0187337106779cdf8"
  instance_type = "t2.medium"
  key_name      = "jenkins-slave-key"

  vpc_security_group_ids = [aws_security_group.k8s-sg.id]

  tags = {
    Name = "k8s_node-${count.index + 1}"
  }
}

resource "aws_instance" "docker_host" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.medium"
  key_name      = "jenkins-slave-key"

  vpc_security_group_ids = [aws_security_group.docker-qa-sg.id]

  tags = {
    Name = "docker_host"
  }
}


resource "null_resource" "generate_inventory" {
  provisioner "local-exec" {
    command = <<EOF
cat <<'EOT' > inventory
[k8s_master]
${aws_instance.k8s_master.public_ip}

[k8s_nodes]
%{ for ip in aws_instance.k8s_node.*.public_ip ~}
${ip}
%{ endfor ~}

[docker_host]
${aws_instance.docker_host.public_ip}

[qa_host]
${aws_instance.qa_host.public_ip}
EOT
EOF
  }
}

resource "null_resource" "delete_inventory" {
  provisioner "local-exec" {
    when = destroy
    command = "rm -f inventory"
  }
}
