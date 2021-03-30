/**
 An object that stores color data and colorTemperature used by the LIFX protocol.
 */
struct LIFXColor {
    /**
     The `Color` of the `LIFXColor`.
     */
    let color: Color
    
    /**
     The color temperature is represented in K° (Kelvin) and is used to adjust the warmness / coolness of a white light,
     which is most obvious when saturation of the `color` property is close zero.
     
     LIFX lights support colorTemperatures in a range 2500° (warm) to 9000° (cool).
     */
    let colorTemperature: UInt16
    
    static var standby = standby = LIFXColor(color: Color.init(red: 20.0, green: 20.0, blue: 20.0), colorTemperature: 22)
    static var red = LIFXColor(color: Color.init(red: 100.0, green: 0.0, blue: 0.0), colorTemperature: 22)
    static var yellow = LIFXColor(color: Color.init(red: 50.0, green: 50.0, blue: 0.0), colorTemperature: 22)
    static var green = LIFXColor(color: Color.init(red: 0.0, green: 100.0, blue: 0.0), colorTemperature: 22)
}

extension ColorLight {
    /**
     Describes the color of a `ColorLight`.
     */
    public Color: LIFXColor
}

extension ColorLight.LIFXColorEnum: CustomStringConvertible {
    public var description: String {
        switch self {
        case .standby:
            return "standby"
        case .red:
            return "red"
        case .yellow:
            return "yellow"
        case .green:
            return "green"
        }
    }
}

// Get an instance of `Device.PowerLevel` from a `ByteBuffer` and set an instance of `Device.PowerLevel` to a `ByteBuffer`.
extension ByteBuffer {
    /**
     Get the `Device.PowerLevel` at `index` from this `ByteBuffer`. Does **not** move the reader index.
     
     The layout of the data encoded in this `ByteBuffer` at `index` must be the following
     [LIFX LAN Docs](https://lan.developer.lifx.com/docs/device-messages#section-statepower-22):
     
     ```
                                     1  1  1  1  1  1
       0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     | HUE | SAT | BRI | KEL | RES | POW |           |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     ```
     
     - warning: This method allows the user to read any of the bytes in the `ByteBuffer`'s storage, including
                _uninitialized_ ones. To use this API in a safe way the user needs to make sure all the requested
                bytes have been written before and are therefore initialized. Note that bytes between (including)
                `readerIndex` and (excluding) `writerIndex` are always initialized by contract and therefore must be
                safe to read.
     - parameters:
        - index: The starting index into `ByteBuffer` containing the `Device.PowerLevel` of interest.
     - returns: A `Device.PowerLevel` instance and its byte size deserialized from this `ByteBuffer`
     - throws: Throws a `ByteBufferError.notEnoughtReadableBytes` if the bytes of interest are not contained in the `ByteBuffer`.
     - precondition: `index` must not be negative.
     */
    func getLIFXColor(at index: Int) throws -> (color: ColorLight.Color, byteSize: Int) {
        precondition(index >= 0, "index must not be negative")
        
        var currentIndex = index
        
        guard let rawHue: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        currentIndex += 2
        guard let rawSaturation: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        currentIndex += 2
        guard let rawBrightness: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        currentIndex += 2
        guard let rawKelvin: Double = getDouble(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        currentIndex += 4
        guard let rawPower: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        
        guard let color = LIFXColor(color: Color(hue: rawHue,
                                                 saturation: rawSaturation,
                                                 brightness: rawBrightness,
                                                 alpha: rawPower), colorTemperature: rawKelvin)
        else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        
        return (color, currentIndex-index)
    }
    
    /**
     Write `powerLevel` into this `ByteBuffer`, moving the writer index forward appropriately.
     
     - parameters:
        - powerLevel: The `Device.PowerLevel` to write.
     */
    mutating func write(powerLevel: Device.PowerLevel) {
        writeInteger(powerLevel.rawValue, endianness: .little)
    }
}
