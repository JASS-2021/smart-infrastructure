import NIO

extension ColorLight {
    /**
     An object that stores color data and colorTemperature used by the LIFX protocol.
     */
    public struct LIFXColor: Equatable {
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
        
    }
}


extension ColorLight.LIFXColor {
    
    public init(_ colorString: String) {
        switch colorString {
        case "red": self = .red
        case "yellow": self = .yellow
        case "green": self = .green
        case "standby": self = .standby
        default: self = .standby
        }
    }
    
    public init(red: Double, green: Double, blue: Double) {
        self = ColorLight.LIFXColor(
            color: Color(red: red, green: green, blue: blue),
            colorTemperature: 5000)
    }
    
    public static var red = ColorLight.LIFXColor(
        color: Color(red: 1.0, green: 0.0, blue: 0.0),
        colorTemperature: 5000
    )
    
    public static var yellow = ColorLight.LIFXColor(
        color: Color(red: 1.0, green: 1.0, blue: 0.0),
        colorTemperature: 5000
    )
    
    public static var green = ColorLight.LIFXColor(
        color: Color(red: 0.0, green: 1.0, blue: 0.0),
        colorTemperature: 5000
    )
    
    public static var standby = ColorLight.LIFXColor(
        color: Color(red: 0.0, green: 0.0, blue: 1.0),
        colorTemperature: 5000
    )
}


// Get an instance of `ColorLight.LIFXColor` from a `ByteBuffer` and set an instance of `ColorLight.LIFXColor` to a `ByteBuffer`.
extension ByteBuffer {
    /**
     Get the `ColorLight.LIFXColor` at `index` from this `ByteBuffer`. Does **not** move the reader index.
     
     The layout of the data encoded in this `ByteBuffer` at `index` must be the following
     [LIFX LAN Docs](https://lan.developer.lifx.com/docs/device-messages#section-statepower-22):
     
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
     ```
     
     - warning: This method allows the user to read any of the bytes in the `ByteBuffer`'s storage, including
     _uninitialized_ ones. To use this API in a safe way the user needs to make sure all the requested
     bytes have been written before and are therefore initialized. Note that bytes between (including)
     `readerIndex` and (excluding) `writerIndex` are always initialized by contract and therefore must be
     safe to read.
     - parameters:
     - index: The starting index into `ByteBuffer` containing the `Device.PowerLevel` of interest.
     - returns: A `ColorLight.LIFXColor` instance and its byte size deserialized from this `ByteBuffer`
     - throws: Throws a `ByteBufferError.notEnoughtReadableBytes` if the bytes of interest are not contained in the `ByteBuffer`.
     - precondition: `index` must not be negative.
     */
    func getLIFXColor(at index: Int) throws -> (color: ColorLight.LIFXColor, byteSize: Int) {
        precondition(index >= 0, "index must not be negative")
        
        var currentIndex = index
        
        guard let rawHue: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        let hue = Double(rawHue) * 360.0 / Double(UInt16.max)
        
        currentIndex += 2
        guard let rawSaturation: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        let saturation = Double(rawSaturation) / Double(UInt16.max)
        
        currentIndex += 2
        guard let rawBrightness: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        let brightness = Double(rawBrightness) / Double(UInt16.max)
        
        currentIndex += 2
        guard let colorTemperature: UInt16 = getInteger(at: currentIndex, endianness: .little) else {
            throw ByteBufferError.notEnoughtReadableBytes
        }
        
        
        let color = ColorLight.LIFXColor(
            color: Color(
                hue: hue,
                saturation: saturation,
                brightness: brightness
            ),
            colorTemperature: colorTemperature
        )
        
        return (color, currentIndex-index)
    }
    
    /**
     Write `Color` into this `ByteBuffer`, moving the writer index forward appropriately.
     
     - parameters:
     - color: The `ColorLight.Color` to write.
     */
    mutating func write(color: ColorLight.LIFXColor) {
        let rawHue = UInt16(clamping: Int(Double(color.color.hue) * Double(UInt16.max) / 360.0))
        writeInteger(rawHue, endianness: .little)
        
        let rawSaturation = UInt16(clamping: Int(color.color.saturation * Double(UInt16.max)))
        writeInteger(rawSaturation, endianness: .little)
        
        let rawBrightness = UInt16(clamping: Int(color.color.brightness * Double(UInt16.max)))
        writeInteger(rawBrightness, endianness: .little)
        
        writeInteger(color.colorTemperature, endianness: .little)
    }
}
