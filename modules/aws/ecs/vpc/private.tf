# Create Private Subnets: One per AZ
resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, var.subnet_bits, count.index + length(data.aws_availability_zones.available.names))
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  depends_on = [aws_subnet.public]

  tags = {
    Name = "${var.name}-private-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Create Elastic IPs for NAT Gateways (one per public subnet)
resource "aws_eip" "nat" {
  count = length(data.aws_availability_zones.available.names)
  tags = {
    Name = "nat-eip-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Create NAT Gateways (one per public subnet)
resource "aws_nat_gateway" "nat" {
  count         = length(data.aws_availability_zones.available.names)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-${data.aws_availability_zones.available.names[count.index]}"
  }
}


# Private route table for each private subnet
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private)
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-private-rt-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_route" "nat_route" {
  count                  = length(aws_subnet.private)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
