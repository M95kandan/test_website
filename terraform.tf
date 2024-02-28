


provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web instances"
}

resource "aws_security_group_rule" "web_ingress" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_ingress" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "k8s_master" {
  ami                    = "ami-05a5bb48beb785bf1"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "jenkins-slave-key"
  tags = {
    Name = "k8s_master"
  }
}

resource "aws_instance" "k8s_slave" {
  count                  = 3
  ami                    = "ami-05a5bb48beb785bf1"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "jenkins-slave-key"
  tags = {
    Name = "k8s_slave-${count.index + 1}"
  }
}

resource "aws_instance" "building_docker" {
  ami                    = "ami-0e670eb768a5fc3d4"
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "jenkins-slave-key"
  tags = {
    Name = "Building docker ec-2"
  }
}

resource "aws_instance" "qa_testing" {
  ami                    = "ami-0e670eb768a5fc3d4"
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "jenkins-slave-key"
  tags = {
    Name = "QA-ec2"
  }
}

resource "null_resource" "ansible_inventory" {
  triggers = {
    update_trigger = timestamp()
  }

  depends_on = [
    aws_instance.k8s_master,
    aws_instance.k8s_slave,
    aws_instance.building_docker,
    aws_instance.qa_testing,
  ]

  provisioner "local-exec" {
    command = <<-EOT
      echo "[k8s_master]" > inventory
      echo "${aws_instance.k8s_master.public_ip}" >> inventory
      echo "[k8s_nodes]" >> inventory
      echo "${join("\n", aws_instance.k8s_slave[*].public_ip)}" >> inventory
      echo "[git_and_docker]" >> inventory
      echo "${aws_instance.building_docker.public_ip}" >> inventory
      echo "[qa_testing]" >> inventory
      echo "${aws_instance.qa_testing.public_ip}" >> inventory
    EOT
  }
}
resource "null_resource" "cleanUpInventory" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f inventory"
  }
}
