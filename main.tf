provider "google" {
  project = "rmaury-se"
  region  = "us-east1-b"
}

resource "google_compute_network" "example_network" {
  name = "example-network"
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.example_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_storage_bucket" "public_bucket" {
  name     = "rmaury-se-public-bucket"
  location = "US"

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  website {
    main_page_suffix = "index.html"
  }
}

resource "google_storage_bucket_iam_binding" "public_bucket_iam" {
  bucket = google_storage_bucket.public_bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

