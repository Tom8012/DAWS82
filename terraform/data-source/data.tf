data "aws_ami" "joindp" {
    most_recent = true
    owners = [805400277926]
    filter {
      name = "name"
      values = ["RHEL-9-DevOps-Practice"]
    }
    filter {
      name = "root-device-type"
      values = ["ebs"]
          }

    filter {
      name = "virtualization-type"
      values = ["hvm"]
          }
          }

// output "ami_id" {
      // value = data.aws_ami.joindp.id
          // }
data "aws_vpc" "default" {
      default = true
  }
output "default_vpc_id" {
  value = data.aws_vpc.default
}