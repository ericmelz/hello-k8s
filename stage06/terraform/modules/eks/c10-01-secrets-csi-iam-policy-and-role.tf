# main.tf (continued)
data "aws_iam_policy_document" "csi_secrets_manager_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "csi_secrets_manager_policy" {
  name   = "CSISecretsManagerPolicy"
  policy = data.aws_iam_policy_document.csi_secrets_manager_policy_doc.json
}

resource "aws_iam_role" "csi_secrets_manager_role" {
  name = "CSISecretsManagerRole"

  assume_role_policy = data.aws_iam_policy_document.csi_secrets_manager_assume_role_policy.json
}

data "aws_iam_policy_document" "csi_secrets_manager_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub"
      values   = ["system:serviceaccount:default:secrets-store-sa"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "csi_secrets_manager_role_policy_attachment" {
  role       = aws_iam_role.csi_secrets_manager_role.name
  policy_arn = aws_iam_policy.csi_secrets_manager_policy.arn
}
