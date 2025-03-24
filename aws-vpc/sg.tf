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

resource "aws_security_group_rule" "allow_all_ingress" {
	type = "ingress"
	security_group_id = aws_security_group.public.id
	cidr_blocks = [ "0.0.0.0/0" ]
	from_port = 0
	to_port = 0
	protocol = "-1"
}


resource "aws_security_group_rule" "allow_all_egress" {
	type = "egress"
	security_group_id = aws_security_group.public.id
	cidr_blocks = [ "0.0.0.0/0" ]
	from_port = 0
	to_port = 0
	protocol = "-1"
}


resource "aws_security_group_rule" "allow_ingress_from_vpc" {
	type = "ingress"
	security_group_id = aws_security_group.private.id
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [aws_vpc.main.cidr_block]
}


resource "aws_security_group_rule" "allow_egress_to_vpc" {
	type = "egress"
	security_group_id = aws_security_group.private.id
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = [aws_vpc.main.cidr_block]
}
