variable "vpc_range" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "availability_zones_all" {}

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_range
}
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.myvpc.id
}
resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.myvpc.id
  count             = length(var.public_subnet_cidr)
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones_all[count.index]

}
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public_subnets[*].id
}

output "public_subnet_jenkins" {
  value = aws_subnet.public_subnets[0].id # Returns only the first subnet
}


#{ for key, value in list_or_map : key => value }

resource "aws_subnet" "private_subnet" {
  for_each = { for idx, az in var.availability_zones_all : idx => {
    cidr = var.private_subnet_cidr[idx]
    az   = az
  } }
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

}

#igw
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myigw"
  }
}

# public rt
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "pub_rt"
  }
}
resource "aws_route_table_association" "pub_rt_association" {
  subnet_id      = aws_subnet.public_subnets[0].id
  route_table_id = aws_route_table.pub_rt.id
}

#private rt
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "priv_rt"
  }
}
resource "aws_route_table_association" "priv_rt_association" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.priv_rt.id
}



