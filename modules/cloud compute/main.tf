resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type 

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network 
    access_config {
    }
  }
}