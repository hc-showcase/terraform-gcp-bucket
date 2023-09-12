variable "bucket_name" {
   description = "The name of the bucket."
}

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = "EU"
  force_destroy = true
}

resource "google_service_account" "bucket" {
  account_id   = "mkaesz-bucket"
  display_name = "My GCS Bucket"
}

resource "google_service_account_key" "bucket" {
  service_account_id = google_service_account.bucket.name
}

resource "google_storage_bucket_iam_member" "member-object" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.bucket.email}"
}

resource "google_storage_bucket_iam_member" "member-bucket" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${google_service_account.bucket.email}"
}
