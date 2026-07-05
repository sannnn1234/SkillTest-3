# outputs.tf
# Expose useful attributes after provisioning.

output "public_ip" {
  description = "Public IP address of the Nginx EC2 instance."
  value       = aws_instance.nginx.public_ip
}

output "public_dns" {
  description = "Public DNS name of the Nginx EC2 instance."
  value       = aws_instance.nginx.public_dns
}

output "website_url" {
  description = "URL to reach the Nginx server in a browser."
  value       = "http://${aws_instance.nginx.public_ip}"
}
