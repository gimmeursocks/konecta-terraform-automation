resource "google_compute_global_address" "lb_ip" {
  name    = "${var.name}-ip"
  project = var.project_id
}

resource "google_compute_backend_service" "default" {
  name        = "${var.name}-backend"
  project     = var.project_id
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name    = "${var.name}-hc"
  project = var.project_id
  http_health_check {
    port = 80
  }
}

resource "google_compute_url_map" "default" {
  name            = "${var.name}-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.name}-fwd"
  project    = var.project_id
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_ip.address
}
