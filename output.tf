output "private_ca_arn" {
  value = aws_acmpca_certificate_authority.private_ca.arn
}

output "trust_anchor_arn" {
  value = aws_rolesanywhere_trust_anchor.applications.arn
}

output "app_role_arn" {
  value = aws_iam_role.app.arn
}

output "app_profile_arn" {
  value = aws_rolesanywhere_profile.app.arn
}

output "private_ca_s3_bucket" {
  value = aws_s3_bucket.private_ca_s3.id
}
