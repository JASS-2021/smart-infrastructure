import Apodini
import ApodiniJobs
import ApodiniLIFX
import ApodiniOpenAPI
import ApodiniREST


struct ExampleWebService: WebService {
    var configuration: Configuration {
        // We expose a RESTful API that is described by an OpenAPI description
        ExporterConfiguration()
            .exporter(RESTInterfaceExporter.self)
            .exporter(OpenAPIInterfaceExporter.self)
        
        // Configures the LIFX device manager to emit more logging information for the example
        LIFXConfiguration(logLevel: .info)
        
        // The DiscoveryJob should run every minute
        Schedule(DiscoveryJob(), on: "* * * * *", \KeyStore.discoveryJob)
    }
    
    var content: some Component {
        Group("discover") {
            DiscoverDevices()
                .operation(.create)
        }
        DevicesComponents()
    }
}


try ExampleWebService.main()
