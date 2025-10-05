resource "google_compute_global_address" "lb_ip" {
  count = var.create_static_ip ? 1 : 0

  project = var.project_id
  name    = "${var.name}-ip"
}

resource "google_compute_backend_service" "main" {
  project       = var.project_id
  name          = "${var.name}-backend"

  protocol    = var.protocol
  port_name   = var.backend_port_name
  timeout_sec = var.backend_timeout

  health_checks = [google_compute_health_check.http.id]
}

resource "google_compute_health_check" "http" {
  project = var.project_id
  name    = "${var.name}-hc"
  http_health_check {
    port         = var.health_check_port
    request_path = var.health_check_path
  }
}

resource "google_compute_url_map" "main" {
  project         = var.project_id
  name            = "${var.name}-url-map"
  default_service = google_compute_backend_service.main.id
}

# If it has SSL
resource "google_compute_target_https_proxy" "main" {
  count = var.enable_ssl ? 1 : 0

  project = var.project_id
  name    = "${var.name}-https-proxy"
  url_map = google_compute_url_map.main.id

  ssl_certificates = var.ssl_certificates
}

# If no SSL
resource "google_compute_target_http_proxy" "main" {
  count = var.enable_ssl ? 0 : 1

  project = var.project_id
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.main.id
}

resource "google_compute_global_forwarding_rule" "https" {
  count = var.enable_ssl ? 1 : 0
  
  project    = var.project_id
  name       = "${var.name}-https"
  target     = google_compute_target_https_proxy.main[0].id
  port_range = "443"
  ip_address = var.create_static_ip ? google_compute_global_address.lb_ip[0].address : null
}

resource "google_compute_global_forwarding_rule" "http" {
  count = var.enable_ssl ? 0 : 1
  
  project    = var.project_id
  name       = "${var.name}-http"
  target     = google_compute_target_http_proxy.main[0].id
  port_range = "80"
  ip_address = var.create_static_ip ? google_compute_global_address.lb_ip[0].address : null
}