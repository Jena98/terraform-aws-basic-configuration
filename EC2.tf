# Import launch template
data "aws_launch_template" "jj-template" {
  name = "jena-terraform"
}

# Create a AutoScale Group
resource "aws_autoscaling_group" "jj-asg" {
  name = "jj-asg"
  vpc_zone_identifier = [aws_subnet.jena-Public-SN-1.id, aws_subnet.jena-Private-SN-1.id]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = data.aws_launch_template.jj-template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.jj-tg.arn]
  health_check_type = "ELB"
  health_check_grace_period = 300

}