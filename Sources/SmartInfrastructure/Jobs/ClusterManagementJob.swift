import Apodini
import ApodiniJobs
import ApodiniLIFX


struct ClusterManagementJob: Job {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    @Environment(\.eventLoopGroup) var eventLoopGroup: EventLoopGroup
    
    let scheduleDecoder = ScheduleDecoder()

    func run() {
        let eventLoop = eventLoopGroup.next()
        guard let schedule = scheduleDecoder.loadJson() else {
            print("nope")
            return
        }
        
        schedule.forEach{ scheduleItem in
            eventLoop.scheduleTask(in: .seconds(Int64(scheduleItem.time))) {
                scheduleItem.actions.forEach { action in
                    guard let device = lifxDeviceManager.device(withName: action.trafficLightName) else {
                        print("No device with the name \"\(action.trafficLightName)\" for junction \"\(action.junctionName)\" wasn't found")
                        return
                    }
                    
                    device.set(lifxColor: ColorLight.LIFXColor(action.color))
                }
            }
        }
    }
    
}
