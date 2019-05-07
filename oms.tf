variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "eu-central-1"
}

resource "aws_instance" "web" {
    ami  = "ami-090f10efc254eaf55"
    instance_type = "t2.micro"
    key_name = "JenkinsAgent"
    vpc_security_group_ids = ["${aws_security_group.tomcat-sg.id}"]

    tags {
	Name = "web-server"		
    }

    connection {
	user = "ec2-user"
	private_key = "${file(var.private_key_path)}"
    }
	
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo chmod 777 /var/www/html/index.html"
    ]
  }
 
  provisioner "remote-exec" {
    inline = [
      "docker run -it --rm tomcat:8.0"
    ]
  }
  

}


resource "aws_security_group" "tomcat-sg" {

  name        = "tomcat_sg"


  # SSH access from anywhere

  ingress {

    from_port   = 22

    to_port     = 22

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }



  # HTTP access from anywhere

  ingress {

    from_port   = 80

    to_port     = 80

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }



  # outbound internet access

  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }
}


///output "aws_instance_public_dns" {
	//value = "${aws_instance.web.public_dns}"
//}
output "aws_instance_public_ip" {
  value = "${aws_instance.web.public_ip}"
}
