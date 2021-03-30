//
//  File.swift
//  
//
//  Created by Paul Schmiedmayer on 3/30/21.
//

import NIO


extension ColorLight {
    /**
     An object that stores color data and colorTemperature used by the LIFX protocol.
     */
    public struct State {
        public let color: ColorLight.LIFXColor
        let powerLevel: ColorLight.PowerLevel
        let label: String
    }
}


// Get an instance of `ColorLight.State` from a `ByteBuffer`.
extension ByteBuffer {
    /**
     Get the `ColorLight.State` at `index` from this `ByteBuffer`. Does **not** move the reader index.
     
     The layout of the data encoded in this `ByteBuffer` at `index` must be the following
     [LIFX LAN Docs](https://lan.developer.lifx.com/docs/information-messages#lightstate---packet-107)
     
     ```
                                     1  1  1  1  1  1
       0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                      HUE                      |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                   SATURATION                  |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                   BRIGHTNESS                  |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                     KELVIN                    |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                    Reserved                   |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                     POWER                     |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                                               |
     |                     LABEL                     |
     |                   (32 Bytes)                  |
     |                                               |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                                               |
     |                   Reserved                    |
     |                                               |
     |                                               |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     ```
     
     - warning: This method allows the user to read any of the bytes in the `ByteBuffer`'s storage, including
                _uninitialized_ ones. To use this API in a safe way the user needs to make sure all the requested
                bytes have been written before and are therefore initialized. Note that bytes between (including)
                `readerIndex` and (excluding) `writerIndex` are always initialized by contract and therefore must be
                safe to read.
     - parameters:
        - index: The starting index into `ByteBuffer` containing the `Device.PowerLevel` of interest.
     - returns: A `ColorLight.State` instance and its byte size deserialized from this `ByteBuffer`
     - throws: Throws a `ByteBufferError.notEnoughtReadableBytes` if the bytes of interest are not contained in the `ByteBuffer`.
     - precondition: `index` must not be negative.
     */
    func getState(at index: Int) throws -> (state: ColorLight.State, byteSize: Int) {
        guard self.readableBytes >= 52 else {
            throw MessageError.messageFormat
        }
        
        var currentIndex = self.readerIndex
        
        let colorGetResult = try self.getLIFXColor(at: currentIndex)
        currentIndex += colorGetResult.byteSize
        
        // Reserved Bytes
        currentIndex += 2
        
        let powerLevelResult = try self.getPowerLevel(at: currentIndex)
        currentIndex += powerLevelResult.byteSize
        
        guard let label = self.getString(at: currentIndex, length: 32) else {
            throw ByteBufferError.notEnoughtBytes
        }
        currentIndex += 32
        
        // Reserved Bytes
        currentIndex += 8
        
        
        return (
            ColorLight.State(
                color: colorGetResult.color,
                powerLevel: powerLevelResult.powerLevel,
                label: label
            ),
            currentIndex-index
        )
    }
}
