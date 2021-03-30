//
//  ChangeDeviceState.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import Apodini
import ApodiniLIFX


struct ChangeDeviceState: Handler {
    @Environment(\.lifxDeviceManager) var lifxDeviceManager: LIFXDeviceManager
    @Parameter(.http(.path)) var name: String
    @Parameter var state: DeviceState
    
    @Throws(.notFound, reason: "No device was found")
    var deviceNotFoundError: ApodiniError
    
    
    func handle() throws -> EventLoopFuture<Device> {
        guard let device = lifxDeviceManager.device(withName: name) else {
            throw deviceNotFoundError(
                reason: "No device with the name \"\(name)\" was found"
            )
        }
        
        return device.set(powerLevel: state.powerLevel)
            .flatMap { _ in
                device.powerLevel.load()
            }
            .transform(to: Device(device))
    }
}

extension LIFXDeviceManager {
    func device(withName name: String) -> NIOLIFX.Device? {
        devices.first(where: { device in
            device.label.wrappedValue?.replacingOccurrences(of: "\0", with: "") == name
        })
    }
}
