admin_backend = softwareSystem "Admin Backend" {
    description "Admin Backend"

    admin_database = container "Admin database" {
        description "Admin database"
        technology "PostgreSQL"
        tags "Database"
        url "https://www.postgresql.org/"
    }

    admin_service = container "Admin service" {
        description "Admin monolith service"
        technology "JavaEE"
        url "https://javaee.github.io/tutorial/"


        audit_logger = component "Audit logger" {
            description "Logs admin actions"

            -> admin_database "Reads from and writes to" "TCP"
        }

        user_manager = component "User manager" {
            description "Handles user administration"

            -> admin_database "Reads from and writes to" "TCP"
            -> private_api "Makes API request to" "REST over HTTPS"
            -> audit_logger "Writes audit logs using"
        }

        content_manager = component "Content manager" {
            description "Handles content administraction"

            -> private_api "Makes API request to" "REST over HTTPS"
            -> audit_logger "Writes audit logs using"
        }

    }
}