resource "aws_subnet" "public_1" {
  # The VPC id
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet
  cidr_block = "192.168.0.0/18"

  # The AZ for the subnet
  availability_zone = "us-west-2a"

  # Required for EKS. Instances launched into the subnet should be assis

  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        = "public-us-west-2a"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}

resource "aws_subnet" "public_2" {
  # The VPC id
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet
  cidr_block = "192.168.64.0/18"

  # The AZ for the subnet
  availability_zone = "us-west-2b"

  # Required for EKS. Instances launched into the subnet should be assis

  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {

    Name                        = "public-us-west-2b"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}


resource "aws_subnet" "private_1" {
  # The VPC id
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet
  cidr_block = "192.168.128.0/18"

  # The AZ for the subnet
  availability_zone = "us-west-2a"

  # Required for EKS. Instances launched into the subnet should be assis

  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        = "private-us-west-2a"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}

resource "aws_subnet" "private_2" {
  # The VPC id
  vpc_id = aws_vpc.main.id

  # The CIDR block for the subnet
  cidr_block = "192.168.192.0/18"

  # The AZ for the subnet
  availability_zone = "us-west-2b"

  # Required for EKS. Instances launched into the subnet should be assis

  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {

    Name                        = "private-us-west-2b"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1

  }
}