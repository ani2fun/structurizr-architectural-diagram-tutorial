backend = softwareSystem "Backend" {
   description "Backend"
   perspectives {
    "Content" "Handles content processing, storage, and retrieval"
   }


   database = container "Database" {
        description "Primary database"
        technology "PostgreSQL"
        tags "Database"
        perspectives {
            "Content" "Handles content metadata storage"
        }
        url "https://www.postgresql.org/"
    }

    minio = container "Minio" {
        description "Object storage"
        technology "S3"
        tags "Store"
        perspectives {
            "Content" "Handles content storage"
        }
        url "https://min.io/"
    }

    backend_services = group "Backend Services" {

        fanout_service = container "Fanout Service" {
            description "Sends emails to users"
            technology "Cloud function"

            -> mail_sender "Makes API request to" "REST over HTTPS"
        }

        content_service = container "Content service" {
            description "Handles content workflows"
            technology "Fast API"
            perspectives {
                "Content" "Handles content processing and retrieval"
            }
            -> minio "Reads from and writes to" "FTP" {
                perspectives {
                    "Content" "Stores and reads content over FTP"
                }
            }
        }

        private_api = container "Private API" {
            description "Private API service"
            technology "Fast API"
            perspectives {
                "Content" "Handles content related private requests"
            }

            -> database "Reads from and writes to" "RESP over TCP"
            -> minio "Reads from and writes to" "FTP"
            -> content_service "Makes API request to" "REST over HTTPS"
            -> fanout_service "Makes API request to" "REST over HTTPS"
        }

        public_api = container "Public API" {
            description "Public API service"
            technology "NodeJS"
            perspectives {
                "Content" "Handles content related public requests"
            }

            -> private_api "Makes API request to" "REST over HTTPS"
        }

    }

}