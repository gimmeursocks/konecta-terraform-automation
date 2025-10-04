resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  project       = var.project_id
  name          = each.key
  location      = lookup(each.value, "location", var.default_location)
  storage_class = lookup(each.value, "storage_class", "STANDARD")

  uniform_bucket_level_access = lookup(each.value, "uniform_bucket_level_access", true)

  versioning {
    enabled = lookup(each.value, "versioning", false)
  }

  labels = merge(
    var.labels,
    lookup(each.value, "labels", {})
  )

  force_destroy = lookup(each.value, "force_destroy", false)
}

resource "google_storage_bucket_iam_member" "members" {
  for_each = var.bucket_iam_members

  bucket = google_storage_bucket.buckets[each.value.bucket].name
  role   = each.value.role
  member = each.value.member
}