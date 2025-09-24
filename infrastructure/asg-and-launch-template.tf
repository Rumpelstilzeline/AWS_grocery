##############################
# Launch Template + ASG + Scaling Policy
##############################

resource "aws_launch_template" "app" {
  name_prefix   = "${var.ecr_repo_name}-lt-"
  image_id      = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    yum update -y
    amazon-linux-extras install -y docker
    systemctl enable --now docker
    usermod -a -G docker ec2-user

    # install unzip and aws cli v2 if missing
    if ! command -v aws >/dev/null 2>&1; then
      yum install -y unzip
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
      unzip /tmp/awscliv2.zip -d /tmp
      /tmp/aws/install
    fi

    REGION="${var.region}"
    ACCOUNT_ID=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep accountId | awk -F'"' '{print $4}')
    IMAGE="${aws_ecr_repository.app.repository_url}:${var.image_tag}"

    # login and run container (will succeed after you push image to ECR)
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
    docker pull $IMAGE || true

    docker run -d --name app -p ${var.app_port}:${var.app_port} --restart unless-stopped \
      --log-driver=awslogs --log-opt awslogs-group=/aws/${var.ecr_repo_name} --log-opt awslogs-region=$REGION \
      $IMAGE
  EOF
  )
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.ecr_repo_name}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  vpc_zone_identifier       = var.private_subnets
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "${var.ecr_repo_name}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "${var.ecr_repo_name}-cpu-target"
  scaling_adjustment     = 0
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

