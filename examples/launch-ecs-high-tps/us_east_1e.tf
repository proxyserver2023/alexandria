data "aws_ec2_instance_type_offerings" "az_offerings" {
  location_type = "availability-zone"

  filter {
    name   = "location"
    values = ["us-east-1e"]
  }
}

output "available_instance_types_us_east_1e" {
  value = data.aws_ec2_instance_type_offerings.az_offerings.instance_types
}
