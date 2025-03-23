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

