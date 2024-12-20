terraform {
    backend "s3" {
        bucket = "terraform-buckets-standard-s3-backend"
        key = "terraform-jenkins"
        region = "ap-southeast-2"
        encrypt = true
        role_arn = "arn:aws:iam::814443606628:role/Terraform-Buckets-StandardS3BackendRole"
        dynamodb_table = "terraform-buckets-standard-s3-backend"
    }
}

provider "aws" {
    region = var.region
}

data "aws_ami" "ami" {
   most_recent = true
   filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "server" {
    ami = data.aws_ami.ami.id   
    instance_type = var.instance_type

    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Name = "Terraform-Jenkins-Instance"
    }
}