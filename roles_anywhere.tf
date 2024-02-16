resource "aws_rolesanywhere_trust_anchor" "applications" {
  name    = "Applications"
  enabled = true

  source {
    source_data {
      acm_pca_arn = aws_acmpca_certificate_authority.private_ca.arn
    }
    source_type = "AWS_ACM_PCA"
  }

  # Wait for the ACMPCA and S3 Policy to be ready to receive requests before setting up the trust anchor
  depends_on = [aws_acmpca_certificate_authority_certificate.private_ca]
}


resource "aws_rolesanywhere_profile" "app" {
  name      = "Applications"
  enabled   = true
  role_arns = [aws_iam_role.app.arn]
}
