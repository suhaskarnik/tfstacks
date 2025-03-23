resource "aws_route_table" "public"{
	vpc_id = aws_vpc.main.id

	tags = merge(var.proj_tags,{
			Name = join("_", [
				"rtb", aws_vpc.main.tags.Name, "pub"
			])
	})
}


resource "aws_route_table" "private"{
	vpc_id = aws_vpc.main.id

	tags = merge(var.proj_tags,{
			Name = join("_", [
				"rtb", aws_vpc.main.tags.Name, "pvt"
			])
	})
}

resource "aws_route_table_association" "public" {
	for_each = {
		for index, subnet in [
			for subnet in aws_subnet.main : subnet if subnet.tags.Public == "true"
		]:
			subnet.tags.Name => subnet
	}
	route_table_id = aws_route_table.public.id
	subnet_id = each.value.id
}


resource "aws_route_table_association" "private" {
	for_each = {
		for index, subnet in [
			for subnet in aws_subnet.main : subnet if subnet.tags.Public == "false"
		]:
			subnet.tags.Name => subnet
	}
	route_table_id = aws_route_table.private.id
	subnet_id = each.value.id
}


resource "aws_route" "public_to_igw" {
	route_table_id = aws_route_table.public.id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.main.id
}
