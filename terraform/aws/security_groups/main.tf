variable "short_name" {}
variable "vpc_id" {}
variable "ingress_cidr_blocks" { default = "0.0.0.0/0" }

resource "aws_security_group" "control" {
  name = "${var.short_name}-control"
  description = "Allow inbound traffic for control nodes"
  vpc_id = "${var.vpc_id}"

  tags {
    KubernetesCluster = "${var.short_name}"
  }

  ingress { # SSH
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Mesos
    from_port = 5050
    to_port = 5050
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Marathon
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Chronos
    from_port = 4400
    to_port = 4400
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Consul
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # all from office
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # self
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = ["${aws_security_group.worker.id}","${aws_security_group.edge.id}","${aws_security_group.ui.id}"]
  }
}

resource "aws_security_group" "ui" {
  name = "${var.short_name}-ui"
  description = "Allow inbound traffic for Mantl UI"
  vpc_id = "${var.vpc_id}"

  tags {
    KubernetesCluster = "${var.short_name}"
  }

  ingress { # HTTP
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # HTTPS
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Consul
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }
}

resource "aws_security_group" "elb" {
  name = "${var.short_name}-elb"
  description = "Allow inbound traffic for elb"
  vpc_id = "${var.vpc_id}"

  tags {
    KubernetesCluster = "${var.short_name}"
  }

  ingress { #HTTP world
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { #HTTPS world
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "edge" {
  name = "${var.short_name}-edge"
  description = "Allow inbound traffic for edge routing"
  vpc_id = "${var.vpc_id}"

  tags {
    KubernetesCluster = "${var.short_name}"
  }

  ingress { # SSH
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # HTTP
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # HTTPS
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # HTTPS world
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }

  ingress { # HTTP world
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }
}

resource "aws_security_group" "worker" {
  name = "${var.short_name}-worker"
  description = "Allow inbound traffic for worker nodes"
  vpc_id = "${var.vpc_id}"

  tags {
    KubernetesCluster = "${var.short_name}"
  }

  ingress { # SSH
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # HTTP
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # HTTPS
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Mesos
    from_port = 5050
    to_port = 5050
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Marathon
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { # Consul
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

  ingress { #all from office 
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${split(",",var.ingress_cidr_blocks)}"]
  }

}

output "edge_security_group" {
  value = "${aws_security_group.edge.id}"
}

output "control_security_group" {
  value = "${aws_security_group.control.id}"
}

output "ui_security_group" {
  value = "${aws_security_group.ui.id}"
}

output "worker_security_group" {
  value = "${aws_security_group.worker.id}"
}

output "elb_security_group" {
  value = "${aws_security_group.elb.id}"
}
