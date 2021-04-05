import Foundation

struct ScheduleDecoder {
    
    func loadJson(_ schedule: String) -> [ScheduleItem]? {
        
        if let url = Bundle.module.resourceURL?.appendingPathComponent("\(schedule).json") {
            do {
                let data = try Data(contentsOf: url)
                print(data)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try decoder.decode(Cluster.self, from: data)
                return turnReadableToUsable(junctionSchedule: jsonData.junctions)
            } catch {
                print("error:\(error)")
                return nil
            }
        }
        let scheduleItem = ScheduleItem(time: 2, actions: [Action(color: "red", trafficLightName: "trafficLight1", junctionName: "duckie1")])
        return [scheduleItem]
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
