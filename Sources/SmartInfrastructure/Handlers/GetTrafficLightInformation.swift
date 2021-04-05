import Apodini
import ApodiniLIFX


struct GetTrafficLightInformation: Handler {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    
    var junctionState: JunctionState
    @Parameter(.http(.path)) var name: String
    
    @Throws(.notFound, reason: "No traffic light was found")
    var trafficLightNotFoundError: ApodiniError

    func handle() throws -> JunctionTrafficLight {
        guard let trafficLightInfo = junctionState.junctionMap[name] else {
            throw trafficLightNotFoundError(
                reason: "No traffic light with the name \"\(name)\" was found"
            )
        }
        return trafficLightInfo
    }
}
