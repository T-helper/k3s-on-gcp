resource "google_compute_subnetwork" "k3s-agents-vpnservers" {
  name          = "k3s-agents-vpnservers-${var.name}"
  network       = var.network
  region        = var.region
  ip_cidr_range = var.cidr_range

  private_ip_google_access = true
}

resource "google_compute_address" "k3s-vpn" {
  name   = "k3s-vpn"
  region = var.region
}
resource "google_compute_router" "router" {
  name    = "k3s-agents-vpnservers-${var.name}"
  region  = var.region
  network = var.network
}

resource "google_compute_router_nat" "nat" {
  name                               = "k3s-agents-vpnservers-${var.name}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.k3s-agents-vpnservers.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "k3s-agnets-vpnservers-firewall-iap" {
  name                              = "k3s-agents-vpnservers-${var.name}"
  network                           = var.network
  source_ranges                     = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = [22]
  }
  target_tags = ["k3s-agent-vpnservers"]
  direction   = "INGRESS"
}

resource "google_compute_firewall" "k3s-agnets-vpnservers" {
  name                              = "k3s-agents-vpnservers-${var.name}"
  network                           = var.network
  source_ranges                     = ["0.0.0.0/0"]
  allow {
    protocol = "tcp,udp"
    ports    = [443]
  }
  target_tags = ["k3s-agent-vpnservers"]
  direction   = "INGRESS"
}