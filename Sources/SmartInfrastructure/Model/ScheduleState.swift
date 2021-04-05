final class ScheduleState {
    var schedule = [ScheduleItem]()
}


struct ScheduleItem: Decodable {
    var time: Int
    var actions: [Action]
}

struct Action: Decodable {
    var color: String
    var trafficLightName: String
    var junctionName: String
}


struct Cluster: Decodable {
    var junctions: [Junction]
}

struct Junction: Decodable {
    var junctionName: String
    var trafficLights: [TrafficLight]
}

struct TrafficLight: Decodable {
    var lightName: String
    var schedule: [LightSchedule]
}

struct LightSchedule: Decodable {
    var time: Int
    var color: String
}

