import Apodini
import ApodiniLIFX

struct SwitchSchedule: Handler {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    @Parameter(.http(.path)) var scheduleName: String
    
    @Throws(.notFound, reason: "No schedule was found")
    var scheduleNotFoundError: ApodiniError
    
    let scheduleDecoder = ScheduleDecoder()
    var scheduleState: ScheduleState
    
    func handle() throws -> Bool {
        
        if(scheduleName != scheduleState.scheduleName) {
            guard let schedule = scheduleDecoder.loadJson(scheduleName) else {
                return false
            }
            scheduleState.schedule = schedule
        }
        return true
    }
}
