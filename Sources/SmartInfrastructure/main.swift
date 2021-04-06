import Apodini
import ApodiniJobs
import ApodiniLIFX
import ApodiniOpenAPI
import ApodiniREST


struct ExampleWebService: WebService {
    
    var junctionState = JunctionState()
    var scheduleState = ScheduleState(scheduleName: "schedule")
    
    var configuration: Configuration {
        // We expose a RESTful API that is described by an OpenAPI description
        ExporterConfiguration()
            .exporter(RESTInterfaceExporter.self)
            .exporter(OpenAPIInterfaceExporter.self)
        
        // Configures the LIFX device manager to emit more logging information for the example
        LIFXConfiguration(interfaceName: "en0", logLevel: .info)
        
        // The DiscoveryJob should run every minute
        Schedule(DiscoveryJob(),
                 on: "* * * * *",
                 \KeyStore.discoveryJob)
        Schedule(ClusterManagementJob(junctionState: junctionState, scheduleState: scheduleState),
                 on: "* * * * *",
                 \KeyStore.clusterManagementJob)
    }
    
    var content: some Component {
        Group("discover") {
            DiscoverDevices()
                .operation(.create)
        }
        DevicesComponents()
        ColorLightComponents()
        ScheduleComponents(scheduleState: scheduleState)
        TrafficLightInformationComponents(junctionState: junctionState)
    }
}


try ExampleWebService.main()
