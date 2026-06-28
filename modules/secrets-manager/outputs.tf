output "database_secret_arn" {
  description = "Database secret ARN."
  value       = aws_secretsmanager_secret.database.arn
}
output "jwt_secret_arn" {
  description = "JWT secret ARN."
  value       = aws_secretsmanager_secret.jwt.arn
}
output "application_secret_arn" {
  description = "Application secret ARN."
  value       = aws_secretsmanager_secret.application.arn
}
output "smtp_secret_arn" {
  description = "SMTP secret ARN."
  value       = aws_secretsmanager_secret.smtp.arn
}
output "secret_arns" {
  description = "All secret ARNs."
  value       = [aws_secretsmanager_secret.database.arn, aws_secretsmanager_secret.jwt.arn, aws_secretsmanager_secret.application.arn, aws_secretsmanager_secret.smtp.arn]
}

