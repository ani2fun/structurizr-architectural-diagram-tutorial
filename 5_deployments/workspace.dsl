// [TYPE]        [NAME]                     [DESCRIPTION]
workspace "5.DEPLOYMENTS" "Showcasing deployment overview on the cloud infrastructure such as Kubernetes" {

    model {
        !include systems/integrations.dsl

        group "Backends" {
            !include systems/backends/backend.dsl
            !include systems/backends/admin_backend.dsl
        }

        group "Frontends" {
            !include systems/frontends.dsl
        }

        group "Users" {
            !include users.dsl
        }

        !include deployment.dsl
    }

    views {
        !include theme.dsl

        systemlandscape "System_Landscape" {
            include *
            autoLayout tb
        }

        deployment backend "Test" "Test_Backend_Deployment" {
            include *
            autoLayout tb
        }

        // systemContext backend "Backend_System_Context" {
        //     include *
        //     autoLayout tb
        // }

        // systemContext admin_backend "Admin_Backend_System_Context" {
        //     include *
        //     autoLayout tb
        // }

        // container backend "Backend_System_Containers" {
        //     include *
        //     autoLayout tb
        // }

        // container admin_backend "Admin_Backend_System_Containers" {
        //     include *
        //     autoLayout tb
        // }

        // component admin_service "Admin_Service_Components" {
        //     include *
        //     autoLayout tb
        // }
    }

}