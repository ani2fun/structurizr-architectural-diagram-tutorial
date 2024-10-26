!const BLACK "#000000"
!const GREY "#EDEDED"
!const ORANGE "#FF8324"


styles {
    element "Element" {
        shape RoundedBox
        background "${GREY}"
        color "${BLACK}"
        stroke "${BLACK}"
    }

    element "User" {
        shape Person
    }

    element "Integration User" {
        shape Robot
    }

    element "Mobile" {
        shape MobileDevicePortrait
    }

    element "Web" {
        shape WebBrowser
    }

    element "Integration" {
        color "${ORANGE}"
    }
}