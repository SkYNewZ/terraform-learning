# Using a single workspace:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "lemairepro"

    workspaces {
      name = "terraform-learning"
    }
  }
}

provider "google" {
  project     = "${var.project}"
  region      = "us-west1"
  credentials = "${var.service_account_key}"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 metadata = {
   ssh-keys = "${var.ssh_connection}"
 }

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

resource "google_compute_firewall" "default" {
 name    = "flask-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["5000"]
 }
}

output "ip" {
 value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}