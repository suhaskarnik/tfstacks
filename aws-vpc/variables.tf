variable "proj_tags" {
	type = map(string)
	default = null
}


variable "vpc" {
	type = object({
		name = string
		base_cidr_block = string
	})
	
}


variable "subnets" {
	type = map(object({
		number = number
		public = bool
	})
	)
}
