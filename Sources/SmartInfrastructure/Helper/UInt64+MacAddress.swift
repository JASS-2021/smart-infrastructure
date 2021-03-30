//
//  UInt64+MacAddress.swift
//  
//
//  Created by Paul Schmiedmayer on 3/28/21.
//

extension UInt64 {
    var macAddressString: String {
        String(self, radix: 16, uppercase: true)
            .enumerated()
            .map {
                $0 > 0 && $0.isMultiple(of: 2) ? ":\($1)" : "\($1)"
            }
            .joined()
    }
}
