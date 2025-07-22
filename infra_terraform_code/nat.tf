resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id  // use public subnet for nat gateway

  tags = {
    Name = "${var.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw] // wait for igw to be created before nat gateway
}
