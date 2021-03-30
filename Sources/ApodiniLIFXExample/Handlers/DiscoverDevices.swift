//
//  DiscoverDevices.swift
//
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import Apodini
import ApodiniLIFX


struct DiscoverDevices: Handler {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    
    
    func handle() -> EventLoopFuture<[Device]> {
        lifxDeviceManager.discoverDevices()
            .map {
                lifxDeviceManager.devices.map {
                    Device($0)
                }
            }
    }
}
