//
//  DeviceState.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import NIOLIFX


enum DeviceState: String, Codable {
    case on
    case off
    
    
    var powerLevel: NIOLIFX.Device.PowerLevel {
        switch self {
        case .on: return .enabled
        case .off: return .standby
        }
    }
    
    
    init(_ powerLevel: NIOLIFX.Device.PowerLevel) {
        switch powerLevel {
        case .enabled: self = .on
        case .standby: self = .off
        }
    }
}
