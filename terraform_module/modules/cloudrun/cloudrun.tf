resource "google_cloud_run_service" "default" {
  name     = "gcr-${var.name}"
  location = var.locaconnection 
  description = var.description

   
    
    template {
    spec {
      containers {
        image = var.image_name
        startup_probe {
          initial_delay_seconds = var.initial_delay_seconds
          timeout_seconds = var.timeout_seconds
          period_seconds = var.period_seconds
          failure_threshold = var.failure_threshold
          tcp_socket {
            port = var.tcp_socket_port
          }
        }
        liveness_probe {
          http_get {
            path = "/"
          }
        }

        container_concurrency = 1
      timeout_seconds = 5 
      volumes {
        
      }

      ports = var.ports
      }
     
      
    }
  }
  metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = var.maxScale
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }

    traffic {
    percent         = 100
    latest_revision = true
    tag = ["newtag"]
    url = ""
    }
   
  }
  autogenerate_revision_name = true



# resource "google_sql_database_instance" "instance" {
#   name             = "cloudrun-sql"
#   region           = "us-east1"
#   database_version = "MYSQL_5_7"
#   settings {
#     tier = "db-f1-micro"
#   }

#   deletion_protection  = "true"
# }