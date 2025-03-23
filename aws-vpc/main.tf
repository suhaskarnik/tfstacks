locals {
	subnets = [
		for key, subnet in var.subnets : {
			key = key
			number = subnet.number
			public = subnet.public
		
			cidr_block = cidrsubnet(var.vpc.base_cidr_block,4, subnet.number)

			name = join("_", [
				aws_vpc.main.tags.Name,
				substr(key,0,1),
				( subnet.public ? "pub" : "pvt" )
			])
		}
	]


	# public_subnets = [
	# 	for each in local.subnets : each if each.subnet_public == true
	# ]
	#
	# private_subnets = [
	# 	for each in local.network_subnets : each if each.subnet_public == false
	# ]

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

	
	tags = merge(var.proj_tags,
		{
			Name = each.value.name  #"${each.value.vpc_id}_${each.value.subnet_key}_${each.value.subnet_public ? "pub" : "pvt" }"
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

