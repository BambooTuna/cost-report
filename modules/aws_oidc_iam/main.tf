variable "prefix" {}
variable "aud" {
  type = string
}

resource "aws_iam_role" "this" {
  name = "${var.prefix}-iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "accounts.google.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "accounts.google.com:aud" = var.aud
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  name        = "${var.prefix}-iam_policy"
  path        = "/"
  description = "IAM policy for access Cost Explorer"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ce:GetCostAndUsage",
        "ce:GetCostForecast"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

output "role_arn" {
  value = aws_iam_role.this.arn
}
