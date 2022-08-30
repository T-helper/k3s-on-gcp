resource "google_compute_region_health_check" "k3s-health-check-ingress" {
  name   = "k3s-health-check-ingress"
  region = var.region

  timeout_sec        = 1
  check_interval_sec = 5

  tcp_health_check {
    port = 32080
  }
}

resource "google_compute_region_backend_service" "k3s-ingress-external" {
  name                  = "k3s-ingress-external"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.k3s-health-check-ingress.id]
  backend {
    group = google_compute_region_instance_group_manager.k3s-agents.instance_group
  }
  ports  = [ "http", "https" ]
}

resource "google_compute_forwarding_rule" "k3s-ingress-external" {
  name                  = "k3s-ingress-external"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_address.k3s-ingress-external.address
  backend_service       = google_compute_region_backend_service.k3s-ingress-external.id
  ports                 = [80,443]
}