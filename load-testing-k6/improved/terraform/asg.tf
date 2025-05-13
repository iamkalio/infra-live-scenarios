resource "aws_autoscaling_group" "web_asg" {
  name             = "web-asg"
  max_size         = 3
  min_size         = 1
  desired_capacity = 1

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}
