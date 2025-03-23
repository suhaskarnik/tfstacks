locals {
	subnets = [
		for key, subnet in var.subnets : {
			key = key
			number = subnet.number
			public = subnet.public
		
			cidr_block = cidrsubnet(var.vpc.base_cidr_block,4, subnet.number)

			name = join("_", [
				"sn", aws_vpc.main.tags.Name,
				substr(key,0,1),
				( subnet.public ? "pub" : "pvt" )
			])
		}
	]
}

resource "aws_vpc" "main" {

	cidr_block = var.vpc.base_cidr_block #"10.0.0.0/16"
	
	tags = merge(var.proj_tags,
		{
			Name = var.vpc.name
		}
	)
}

resource "aws_subnet" "main" {
	for_each = {
		for index, subnet in local.subnets:
			subnet.name => subnet
	}
	vpc_id = aws_vpc.main.id
	availability_zone = "us-east-1${substr(each.value.key,0,1)}"
	cidr_block = each.value.cidr_block
	
	map_public_ip_on_launch = each.value.public ? true : false
	
	tags = merge(var.proj_tags,
		{
			Name = each.value.name  
			Public = each.value.public
		}
	)
}


resource "aws_internet_gateway" "main" {
  # One Internet Gateway per VPC

  vpc_id = aws_vpc.main.id
	
	tags = merge(var.proj_tags,
		{
			Name = "igw_${aws_vpc.main.tags.Name}"
		}
	)
}

