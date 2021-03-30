//
//  LIFXConfiguration.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import Apodini
import Logging


/// A `Configuration` used for configuring the LFIX device manager.
public final class LIFXConfiguration: Configuration {
    let interfaceName: String
    let logLevel: Logger.Level
    
    
    /// Creates a new LIFXConfiguration used used for configuring the LIFX device manager.
    /// - Parameters:
    ///   - interfaceName: The IPv4 network interface that should be used.
    ///   - logLevel: The logging level used by the logger.
    public init(interfaceName: String = "en0", logLevel: Logger.Level = .error) {
        self.interfaceName = interfaceName
        self.logLevel = logLevel
    }
    
    
    public func configure(_ app: Application) {
        var logger = Logger(label: "lifx")
        logger.logLevel = logLevel
        
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        
        guard let networkInterface = getNetworkInterface(logger) else {
            logger.critical("Could not find a suiting network interface.")
            return
        }
        
        guard let lifxDeviceManager = try? LIFXDeviceManager(using: networkInterface, on: eventLoopGroup, logLevel: logLevel) else {
            logger.critical(
                """
                Could not create a LIFXDeviceManager. Access the LIFXDeviceManager using the `@Environment` will create a runtime crash.
                """
            )
            return
        }
        
        app.lifxDeviceManager = lifxDeviceManager
        
        // Start discovering devices when the web services is started
        lifxDeviceManager.discoverDevices()
    }
    
    private func getNetworkInterface(_ logger: Logger) -> NIONetworkDevice? {
        guard let networkInterfaces = try? System.enumerateDevices() else {
            logger.critical("Could not find any network interface.")
            return nil
        }
        
        for interface in networkInterfaces {
            if case .v4 = interface.address, interface.name == interfaceName {
                return interface
            }
        }
        
        logger.critical(
            """
            Didn't find a interface with the name \"\(interfaceName)\" that on the device.

            The available IPv4 network iterfaces are:
            \(networkInterfaces
                .compactMap { interface -> String? in
                    if case .v4 = interface.address, let address = interface.address {
                        return "\(interface.name): \(address.description)"
                    } else {
                        return nil
                    }
                }
                .joined(separator: "\n")
            )
            """
        )
        
        return nil
    }
}
