data "aws_iam_policy" "s3_readonly" {
  name = "AmazonS3ReadOnlyAccess"
}

#
# Creating IAM Role the application will assume to.
#
# Considion in the assume_role_policy is to limit the policy access to only
# certain OrganizationUnit and only from our Private CA
#
resource "aws_iam_role" "app" {
  name = "RolesAnywhereAppRole"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
      ]
      Principal = {
        Service = "rolesanywhere.amazonaws.com",
      }
      Effect = "Allow"
      Sid    = ""
      Condition = {
        StringEquals = {
            "aws:PrincipalTag/x509Subject/OU" = "Dev"
        }
        ArnEquals = {
            "aws:SourceArn" = aws_acmpca_certificate_authority.private_ca.arn
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "app_s3_readonly" {
  role       = aws_iam_role.app.name
  policy_arn = data.aws_iam_policy.s3_readonly.arn
}