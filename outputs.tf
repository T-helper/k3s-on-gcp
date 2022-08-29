output "ingress_lb_ip_address" {
  value = google_compute_address.k3s-ingress-external.address
}
