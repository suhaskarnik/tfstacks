resource "aws_security_group" "public" {
	vpc_id =aws_vpc.main.id
	
	tags = merge(var.proj_tags,
		{
			Name = "sg_${aws_vpc.main.tags.Name}_pub"
		}
	)
}


resource "aws_security_group" "private" {

	vpc_id = aws_vpc.main.id
	
	tags = merge(var.proj_tags,
		{
			Name = "sg_${aws_vpc.main.tags.Name}_pvt"
		}
	)
}


resource "aws_network_acl" "public" {
	vpc_id = aws_vpc.main.id
	
	tags = merge(var.proj_tags,
		{
			Name = "nacl_${aws_vpc.main.tags.Name}_pub"
		}
	)
}

resource "aws_network_acl" "private" {
	vpc_id = aws_vpc.main.id
	
	tags = merge(var.proj_tags,
		{
			Name = "nacl_${aws_vpc.main.tags.Name}_pvt"
		}
	)
}

resource "aws_network_acl_association" "public" {
	for_each = {
		for index, subnet in [
			for subnet in aws_subnet.main : subnet if subnet.tags.Public == "true"
		]:
			subnet.tags.Name => subnet
	}
	network_acl_id = aws_network_acl.public.id
	subnet_id = each.value.id
}


resource "aws_network_acl_association" "private" {
	for_each = {
		for index, subnet in [
			for subnet in aws_subnet.main : subnet if subnet.tags.Public == "false"
		]:
			subnet.tags.Name => subnet
	}
	network_acl_id = aws_network_acl.private.id
	subnet_id = each.value.id
}



