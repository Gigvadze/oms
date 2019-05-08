variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "eu-central-1"
}

resource "aws_instance" "web" {
    ami  = "ami-09def150731bdbcc2"
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
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      //"sudo scp -i ~/Terraform/JenkinsAgent.pem /var/lib/jenkins/workspace/omspipe/target/OMS.war ec2-user@$ip:/home/ec2-user/ "
     // "sudo systemctl enable apache2",
     // "sudo systemctl start apache2",
      //"sudo chmod 777 /var/www/html/index.html"
      
    ]
  }

  provisioner "file" {
    source      = "/app/target/OMS.war"
    destination = "/home/ec2-user/OMS.war"
  }

  provisioner "remote-exec" {
    inline = [
	    "docker image pull tomcat:8-jre8",
      "touch Dockerfile",
      "cat <<EOF > Dockerfile",
      "From tomcat:8.0",
      "MAINTAINER 'henadiy'",
      "ADD OMS.war /usr/local/tomcat/webapps/",
      "EOF",
     
      "docker build -t webserver .",
      //"docker run -it -d --rm -p 8080:8080 -v $(pwd)/target/OMS.war:/usr/local/tomcat/webapps/OMS.war webserver"
      "docker run -it -d --rm -p 8080:8080 webserver",
      //"docker run -it  --rm -p 80:8080  -v /var/lib/jenkins/workspace/omspipe/target:/usr/local/tomcat/webapps/ --name tomcat:8.0"
      //"docker cp tomcat:8.0:/home/ec2-user/OMS.war /usr/local/tomcat/webapps/"
      //
      //"/cat << EOT > Dockerfile",
      //"FROM tomcat:8.0",
      //"COPY OMS.war /usr/local/tomcat/webapps/",
      //"EOT"
      //  sudo du -sh //
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

    to_port     = 8080

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
