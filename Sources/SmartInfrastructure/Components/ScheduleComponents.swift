import Apodini

struct ScheduleComponents: Component {
    var scheduleState: ScheduleState
    
    var content: some Component {
        Group("switch-schedule") {
            SwitchSchedule(scheduleState: scheduleState)
                .operation(.update)
        }
    }
}
