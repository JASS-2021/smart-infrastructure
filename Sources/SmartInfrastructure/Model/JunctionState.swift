import Foundation
import Apodini

final class JunctionState {
    
    var junctionMap = ["traffic_light_1_1":JunctionTrafficLight(color: "red",
                                                                options: [JunctionOption(direction: 0, next: "traffic_light_2_5"),
                                                                          JunctionOption(direction: 1, next: "traffic_light_2_6")]),
                       "traffic_light_1_2":JunctionTrafficLight(color: "red",
                                                                options: [JunctionOption(direction: 0, next: "traffic_light_2_6"),
                                                                          JunctionOption(direction: 2, next: "traffic_light_2_4")]),
                       "traffic_light_1_3":JunctionTrafficLight(color: "red",
                                                                options: [JunctionOption(direction: 1, next: "traffic_light_2_4"),
                                                                          JunctionOption(direction: 2, next: "traffic_light_2_5")]),
                       "traffic_light_2_4":JunctionTrafficLight(color: "red",
                                                                options: [JunctionOption(direction: 1, next: "traffic_light_1_3"),
                                                                          JunctionOption(direction: 2, next: "traffic_light_1_2")]),
                       "traffic_light_2_5":JunctionTrafficLight(color: "red",
                                                                options: [JunctionOption(direction: 0, next: "traffic_light_1_1"),
                                                                          JunctionOption(direction: 2, next: "traffic_light_1_3")]),
                       "traffic_light_2_6":JunctionTrafficLight(color: "red",
                                                                options: [JunctionOption(direction: 0, next: "traffic_light_1_2"),
                                                                          JunctionOption(direction: 1, next: "traffic_light_1_1")])
    ]
}

struct JunctionTrafficLight: Content {
    var color: String
    var options: [JunctionOption]
}

struct JunctionOption: Encodable {
    var direction: Int
    var next: String
}
