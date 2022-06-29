
output "public_ip" {
  value = aws_instance.ghost.public_ip
}

output "ssh_public_key" {
  sensitive = true
  value = tls_private_key.ssh.public_key_openssh
}

output "ssh_private_key" {
  sensitive = true
  value = tls_private_key.ssh.private_key_openssh
}
