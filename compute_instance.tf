data "template_file" "k3s-agent-startup-script" {
  template = file("${path.module}/templates/agent.sh")
  vars = {
    token          = var.token
    server_address = var.server_address
  }
}

resource "google_compute_instance" "k3s-agent" {
  machine_type = var.machine_type
  name         = "k3s-agent-${var.name}"
  tags         = ["k3s", "k3s-worker"]

  metadata_startup_script = data.template_file.k3s-agent-startup-script.rendered

  metadata = {
    ssh-keys = file("${path.module}/templates/ssh_keys.pub")
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20220610"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

 

  lifecycle {
    ignore_changes = [attached_disk]
  }
}