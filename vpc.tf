##
resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  instance_tenancy = "default"

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}


output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id."
  # Setting the output value as sensitive prevents terraform from showing its value in plan and apply (only output)
  sensitive = false
}
