import Apodini
import ApodiniJobs
import ApodiniLIFX


struct ClusterManagementJob: Job {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    @Environment(\.eventLoopGroup) var eventLoopGroup: EventLoopGroup
    
    var junctionState: JunctionState
    var scheduleState: ScheduleState
    
    let scheduleDecoder = ScheduleDecoder()
    
    func run() {
        let eventLoop = eventLoopGroup.next()
        
        if scheduleState.standby {
            scheduleState.schedule.filter { scheduleItem in
                return scheduleItem.time == 0
            }.first!.actions.forEach { action in
                guard let device = lifxDeviceManager.device(withName: action.trafficLightName) else {
                    print("No device with the name \"\(action.trafficLightName)\" for junction \"\(action.junctionName)\" wasn't found")
                    return
                }
                
                device.set(lifxColor: ColorLight.LIFXColor("standby"))
            }
            return
        }
        
        scheduleState.schedule.forEach{ scheduleItem in
            eventLoop.scheduleTask(in: .seconds(Int64(scheduleItem.time))) {
                scheduleItem.actions.forEach { action in
                    
                    guard let device = lifxDeviceManager.device(withName: action.trafficLightName) else {
                        print("No device with the name \"\(action.trafficLightName)\" for junction \"\(action.junctionName)\" wasn't found")
                        return
                    }
                    
                    device.set(lifxColor: ColorLight.LIFXColor(action.color))
                    
                    guard var trafficLightState = junctionState.junctionMap[action.trafficLightName] else {
                        print("No device with the name \"\(action.trafficLightName)\" for junction \"\(action.junctionName)\" wasn't found")
                        return
                    }
                    trafficLightState.color = action.color
                    junctionState.junctionMap.updateValue(trafficLightState, forKey: action.trafficLightName)
                    
                }
            }
        }
    }
    
}
