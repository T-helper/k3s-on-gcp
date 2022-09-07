data "template_file" "k3s-agent-vpnservers-startup-script" {
  template = file("${path.module}/templates/agent.sh")
  vars = {
    token          = var.token
    server_address = var.server_address
  }
}

resource "google_compute_instance_template" "k3s-agent-vpnservers" {
  name_prefix  = "k3s-agent-${var.name}-"
  machine_type = var.machine_type

  tags = ["k3s", "k3s-agent-vpnservers"]

  metadata_startup_script = data.template_file.k3s-agent-vpnservers-startup-script.rendered

  metadata = {
  }

  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network
    subnetwork = google_compute_subnetwork.k3s-agents-vpnservers.self_link
  }

  shielded_instance_config {
    enable_secure_boot = false
  }

  service_account {
    email = var.service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "k3s-agents-vpnservers" {
  name = "k3s-agents-vpnservers-${var.name}"

  base_instance_name = "k3s-agent-vpnservers-${var.name}"
  region             = var.region

  version {
    instance_template = google_compute_instance_template.k3s-agent-vpnservers.id
  }

  target_size = var.target_size

  update_policy {
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 3
  }

  depends_on = [google_compute_router_nat.nat]
}
