output "vpn_ip_address" {
  value = google_compute_address.k3s-agents-vpnservers.address
}
