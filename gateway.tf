resource "aws_internet_gateway" "mydario-assignemnt-igw" {
  vpc_id = aws_vpc.mydario-assignemnt-vpc.id

  tags = {
    Name = "mydario-assignemnt-igw"
  }
}
