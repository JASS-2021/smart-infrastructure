//
//  DiscoveryJob.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import Apodini
import ApodiniJobs
import ApodiniLIFX


struct KeyStore: EnvironmentAccessible {
    var discoveryJob: DiscoveryJob
}


struct DiscoveryJob: Job {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager

    func run() {
        lifxDeviceManager.discoverDevices()
    }
}
