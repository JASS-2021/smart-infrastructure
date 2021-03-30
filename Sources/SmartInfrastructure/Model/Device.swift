//
//  Device.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import Apodini
import NIOLIFX


struct Device: Content {
    let address: String
    let name: String?
    let state: DeviceState?
    
    init(_ device: NIOLIFX.Device) {
        self.address = device.address.macAddressString
        self.name = device.label.wrappedValue?.replacingOccurrences(of: "\0", with: "")
        
        guard let powerLevel = device.powerLevel.wrappedValue else {
            self.state = nil
            return
        }
        
        self.state = DeviceState(powerLevel)
    }
}
