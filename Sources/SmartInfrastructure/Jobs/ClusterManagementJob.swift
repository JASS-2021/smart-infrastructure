import Apodini
import ApodiniJobs
import ApodiniLIFX


struct ClusterManagementJob: Job {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    @Environment(\.eventLoopGroup) var eventLoopGroup: EventLoopGroup
    
    let scheduleDecoder = ScheduleDecoder()

    func run() {
        let eventLoop = eventLoopGroup.next()
        guard let junctionSchedule = scheduleDecoder.loadJson() else {
            print("nope")
            return
        }
        let timedSchedule: [ScheduleItem] = scheduleDecoder.turnReadableToUsable(junctionSchedule: junctionSchedule)
        
        timedSchedule.forEach{ scheduleItem in
            
        }
        
        eventLoop.scheduleTask(in: .seconds(4)) {
            print(timedSchedule)
            print(4)
        }
        
    }
}
