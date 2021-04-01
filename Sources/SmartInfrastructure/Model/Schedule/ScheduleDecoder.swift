import Foundation

struct ScheduleDecoder {
    
    func loadJson() -> [Junction]? {
        
        if let url = Bundle.main.url(forResource: "Resources/schedule", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                print(data)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try decoder.decode(Cluster.self, from: data)
                return jsonData.junctions
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    func turnReadableToUsable(junctionSchedule: [Junction]) -> [ScheduleItem] {
        var map: [Int: ScheduleItem] = [:]

        junctionSchedule.forEach{junction in
            junction.trafficLights.forEach{trafficLight in
                map = trafficLight.schedule.reduce(map) { (map, schedule) in
                    let action = Action(color: schedule.color,
                                        trafficLightName: trafficLight.lightName,
                                        junctionName: junction.junctionName)
                    var map = map
                    map[schedule.time] = map[schedule.time] ?? ScheduleItem(time: schedule.time, actions: [])
                    map[schedule.time]!.actions.append(action)
                    return map
                }
            }
        }
        return Array(map.values)
    }
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


struct ScheduleItem: Decodable {
    var time: Int
    var actions: [Action]
}

struct Action: Decodable {
    var color: String
    var trafficLightName: String
    var junctionName: String
}
