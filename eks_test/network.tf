data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name = "finops-test"
}
#
#resource "aws_vpc" "main" {
#  cidr_block           = "10..0.0/16"
#  enable_dns_hostnames = true
#  enable_dns_support   = true
#  tags = {
#    Name = "velero-test-vpc"
#  }
#}
#
#resource "aws_subnet" "public" {
#  count             = 3
#  vpc_id            = aws_vpc.main.id
#  cidr_block        = slice(["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"], count.index, count.index + 1)[0]
#  availability_zone = slice(data.aws_availability_zones.available.names, count.index, count.index + 1)[0]
#
#  map_public_ip_on_launch = true
#
#  tags = {
#    Name                                                  = "Public-${count.index}"
#    "kubernetes.io/cluster/${local.cluster_name_primary}" = "shared"
#    "kubernetes.io/role/elb"                              = 1
#  }
#}
#
#resource "aws_subnet" "private" {
#  count                   = 3
#  vpc_id                  = aws_vpc.main.id
#  cidr_block              = slice(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index, count.index + 1)[0]
#  availability_zone       = slice(data.aws_availability_zones.available.names, count.index, count.index + 1)[0]
#  map_public_ip_on_launch = true
#  tags = {
#    Name                                                  = "Private-${count.index}"
#    "kubernetes.io/cluster/${local.cluster_name_primary}" = "shared"
#    "kubernetes.io/role/internal-elb"                     = 1
#  }
#}
#resource "aws_internet_gateway" "this" {
#  vpc_id = aws_vpc.main.id
#
#}
#resource "aws_eip" "nat" {
#  count = 1
#}
#
#resource "aws_route_table" "eks_route_table" {
#  vpc_id = aws_vpc.main.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.this.id
#  }
#}
#
#resource "aws_route_table_association" "eks_route_table_association1" {
#  count          = length(aws_subnet.public.*.id)
#  subnet_id      = aws_subnet.public[count.index].id
#  route_table_id = aws_route_table.eks_route_table.id
#}
#resource "aws_route_table_association" "eks_route_table_association2" {
#  count          = length(aws_subnet.private.*.id)
#  subnet_id      = aws_subnet.private[count.index].id
#  route_table_id = aws_route_table.eks_route_table.id
#}
#
#resource "aws_nat_gateway" "this" {
#  count         = 1
#  subnet_id     = aws_subnet.public[0].id
#  allocation_id = aws_eip.nat[0].id
#}