import Apodini

struct TrafficLightInformationComponents: Component {
    
    var junctionState: JunctionState
    
    var content: some Component {
        Group("traffic-light-info") {
            GetTrafficLightInformation(junctionState: junctionState)
        }
    }
}
