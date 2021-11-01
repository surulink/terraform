resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = var.instance_machine_type
  zone         = var.instance_zone

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = var.subnet_name
    access_config {
    }
  }
  metadata_startup_script = var.startup_script

  service_account {
    scopes = ["storage-rw"]
  }

  allow_stopping_for_update = true
}

resource "google_compute_subnetwork" "public-subnetwork" {
name = "terraform-subnetwork"
ip_cidr_range = "10.2.0.0/16"
region = "us-central1"
network = google_compute_network.vpc_network.name
}

resource "google_compute_firewall" "default" {
  name    = "allow-jenkins-rule"
  network = "default"
  source_ranges = var.source_ranges
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}
