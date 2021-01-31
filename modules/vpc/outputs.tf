output "vpc_id" {
  value = aws_vpc.demo.id
}

output "vpc_subnets_id" {
  value = aws_subnet.public[*].id
}
