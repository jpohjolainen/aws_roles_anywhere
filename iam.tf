data "aws_iam_policy" "s3_readonly" {
  name = "AmazonS3ReadOnlyAccess"
}

#
# Creating IAM Role the application will assume to.
#
# Condition in the assume_role_policy is to limit the policy access to only
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
        ## The role can be pinned/limited to only a certain common_name or f.ex. organizational_unit
        # StringEquals = {
        #     "aws:PrincipalTag/x509Subject/CN" = var.ca_subject.common_name
        # }
        ArnEquals = {
            "aws:SourceArn" = aws_rolesanywhere_trust_anchor.applications.arn
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "app_s3_readonly" {
  role       = aws_iam_role.app.name
  policy_arn = data.aws_iam_policy.s3_readonly.arn
}