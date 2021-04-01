import Apodini

struct ColorLightComponents: Component {
    var content: some Component {
        Group("colorlights") {
            SwitchColorDeviceState()
                .operation(.update)
        }
    }
}
