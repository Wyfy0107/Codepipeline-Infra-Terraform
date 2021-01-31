resource "aws_vpc" "demo" {
  cidr_block = var.vpc_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "vpc-demo"
    }
  )
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.demo.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "subnet-demo"
    }
  )
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = merge(
    local.common_tags,
    {
      Name = "gateway_demo"
    }
  )
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "routetable_demo"
    }
  )
}

resource "aws_route_table_association" "demo" {
  count          = 2
  route_table_id = aws_route_table.demo.id
  subnet_id      = aws_subnet.public[count.index].id
}
