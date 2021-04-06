import Apodini
import ApodiniLIFX

struct Standby: Handler {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    @Parameter(.http(.path)) var standbyOn: Bool
    
    var scheduleState: ScheduleState
    
    func handle() throws -> Bool {
        scheduleState.standby = standbyOn
        return true
    }
}
