//
//  Application+LIFX.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//


import Apodini
@_exported import NIOLIFX


extension Application {
    struct LIFXDeviceManagerKey: StorageKey {
        typealias Value = LIFXDeviceManager
    }
    
    
    /// Holds the `LIFXDeviceManager` of the web service.
    public internal(set) var lifxDeviceManager: LIFXDeviceManager {
        get {
            guard let lifxDeviceManager = self.storage[LIFXDeviceManagerKey.self] else {
                fatalError(
                    "You must use a `LIFXConfiguration` in your `WebService` configuration before you can access the `lifxDeviceManager`."
                )
            }
            
            return lifxDeviceManager
        }
        set {
            self.storage[LIFXDeviceManagerKey.self] = newValue
        }
    }
}
