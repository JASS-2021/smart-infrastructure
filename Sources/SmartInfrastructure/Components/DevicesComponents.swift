//
//  DevicesComponents.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

import Apodini

struct DevicesComponents: Component {
    var content: some Component {
        Group("devices") {
            GetAllDevices()
            ChangeDeviceState()
                .operation(.update)
        }
    }
}
