import Apodini
import ApodiniLIFX

struct SwitchColorDeviceState: Handler {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    @Parameter(.http(.path)) var name: String
    @Parameter var color: ColorLightState
    
    @Throws(.notFound, reason: "No device was found")
    var deviceNotFoundError: ApodiniError
    
    
    func handle() throws -> EventLoopFuture<Device> {
        guard let device = lifxDeviceManager.device(withName: name) else {
            throw deviceNotFoundError(
                reason: "No device with the name \"\(name)\" was found"
            )
        }
        
//        let lifxColor = ColorLight.LIFXColor(color)
        
        return device.set(lifxColor: ColorLight.LIFXColor(color.rawValue))
            .flatMap { _ in
                device.state.load()
            }
            .transform(to: Device(device))
        
    }
}
