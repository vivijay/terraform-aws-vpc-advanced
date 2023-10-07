
## VPC peering with default vpc

resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_enabled ? 1 : 0
  # Requester
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.requester_vpc_id
  auto_accept   = true

  tags = merge({
    Name = "VPC Peering between default and ${var.project_name}"
  },
  var.common_tags
  )
}

resource "aws_route" "default_route" {
    count = var.is_peering_enabled ? 1 : 0
  route_table_id            = var.default_route_table_id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
 # depends_on                = [aws_route_table.testing]
}

#add route in roboshop public route table
resource "aws_route" "public_peering" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
 # depends_on                = [aws_route_table.testing]
}

#add route in roboshop private route table
resource "aws_route" "private_peering" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
 # depends_on                = [aws_route_table.testing]
}

resource "aws_route" "database_peering" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
 # depends_on                = [aws_route_table.testing]
}