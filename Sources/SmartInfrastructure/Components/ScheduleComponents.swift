import Apodini

struct ScheduleComponents: Component {
    var scheduleState: ScheduleState
    
    var content: some Component {
        Group("switch-schedule") {
            SwitchSchedule(scheduleState: scheduleState)
                .operation(.update)
            Group("standby") {
                Standby(scheduleState: scheduleState)
                    .operation(.update)
            }
        }
    }
}
