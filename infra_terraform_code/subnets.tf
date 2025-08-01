resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = var.zone1

  tags = {
    "Name"                                                 = "${var.env}-private-${var.zone1}"
    "kubernetes.io/role/internal-elb"                      = "1"  // This tag is used to indicate that this subnet should be used for internal load balancers.
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = var.zone2

  tags = {
    "Name"                                                 = "${var.env}-private-${var.zone2}"
    "kubernetes.io/role/internal-elb"                      = "1"
    
  }
}



resource "aws_subnet" "public_zone1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = var.zone1
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                 = "${var.env}-public-${var.zone1}"
    "kubernetes.io/role/elb"                               = "1"  // this tag is used to indicate that this subnet should be used for external load balancers.
    
  }
}

resource "aws_subnet" "public_zone2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = var.zone2
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                 = "${var.env}-public-${var.zone2}"
    "kubernetes.io/role/elb"                               = "1" // this tag is used to indicate that this subnet should be used for external load balancers.
    
  }
}