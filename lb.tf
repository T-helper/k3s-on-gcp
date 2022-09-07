resource "google_compute_region_health_check" "k3s-health-check-vpnservers" {
  name   = "k3s-health-check-vpnservers"
  region = var.region

  timeout_sec        = 1
  check_interval_sec = 5

  tcp_health_check {
    port = 443
  }
}

resource "google_compute_region_backend_service" "k3s-vpnservers-tcp-external" {
  name                  = "k3s-ingress-external"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  protocol              = "TCP"
  health_checks         = [google_compute_region_health_checkk3s-health-check-vpnservers.id]
  backend {
    group = google_compute_region_instance_group_manager.k3s-agents-vpnservers.instance_group
  }
}

resource "google_compute_region_backend_service" "k3s-vpnservers-udp-external" {
  name                  = "k3s-ingress-external"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  protocol              = "UDP"
  health_checks         = [google_compute_region_health_check.k3s-health-check-vpnservers.id]
  backend {
    group = google_compute_region_instance_group_manager.k3s-agents-vpnservers.instance_group
  }
}

resource "google_compute_forwarding_rule" "k3s-vpnservers-tcp-external" {
  name                  = "k3s-ingress-external"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_address.k3s-ingress-external.address
  backend_service       = google_compute_region_backend_service.k3s-vpnservers-tcp-external.id
  ports                 = [443]
  protocol              = "TCP"
}

resource "google_compute_forwarding_rule" "k3s-vpnservers-udp-external" {
  name                  = "k3s-ingress-external"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_address.k3s-ingress-external.address
  backend_service       = google_compute_region_backend_service.k3s-vpnservers-tcp-external.id
  ports                 = [443]
  protocol              = "UDP"
}