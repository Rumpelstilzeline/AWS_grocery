data "aws_caller_identity" "current" {}

# Get latest Amazon Linux 2 AMI via SSM parameter (region stable)
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

