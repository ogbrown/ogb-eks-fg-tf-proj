
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${var.short_project_name}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/policies/aws-load-balancer-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attachment" {
  role       = data.aws_iam_role.pod_execution_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

