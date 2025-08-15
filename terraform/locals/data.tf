// output "ami_id" {
      // value = data.aws_ami.joindp.id
          // }
data "aws_vpc" "default" {
      default = true
  }
output "default_vpc_id" {
  value = data.aws_vpc.default
}