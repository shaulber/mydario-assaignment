resource "aws_vpc" "mydario-assignemnt-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "mydario-assignemnt-vpc"
  }
}
