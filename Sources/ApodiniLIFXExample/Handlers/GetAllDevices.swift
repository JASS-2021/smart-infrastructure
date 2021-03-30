//
//  GetAllDevices.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import Apodini
import ApodiniLIFX


struct GetAllDevices: Handler {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    
    
    func handle() -> [Device] {
        lifxDeviceManager.devices.map {
            Device($0)
        }
    }
}
