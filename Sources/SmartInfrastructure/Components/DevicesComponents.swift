import Apodini

struct DevicesComponents: Component {
    var content: some Component {
        Group("devices") {
            GetAllDevices()
            ChangeDeviceState()
                .operation(.update)
        }
    }
}
