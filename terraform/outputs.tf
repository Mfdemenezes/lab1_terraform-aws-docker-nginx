output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Elastic IP attached to the instance"
  value       = aws_eip.web.public_ip
}

output "http_url" {
  description = "HTTP URL of the application"
  value       = "http://${aws_eip.web.public_ip}"
}
