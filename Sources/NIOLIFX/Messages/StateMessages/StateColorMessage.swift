import NIO

/**
 StateColorMessage
 
 Message that carries a `LIFXColor` and a `Label` payload.
 */
class StateColorMessage: Message {
    
    override class var type: UInt16 {
        107
    }
    /**
     The `String`-label carried by the message.
     */
    let color: LIFXColor
    let label: String
    
    /**
     Initializes a new message with a provided `label`.
     
     - parameters:
        - target: `Target` of the `Message` indicating where the `Message` should be send to.
        - requestAcknowledgement: Indicates that a acknowledgement message is required.
        - requestResponse: Indicates that a response message is required.
        - label: The `String`-label carried by the message.
     - precondition: The `label`'s UTF-8 byte representation must be 32 bytes long.
     */
    init(target: Target,
         requestAcknowledgement: Bool,
         requestResponse: Bool,
         color: LIFXColor,
         label: String) {
        precondition(Array(label.utf8).count == 32, "The `label`'s UTF-8 byte representation must be 32 bytes long.")
        
        self.color = color
        self.label = label
        super.init(target: target,
                   requestAcknowledgement: requestAcknowledgement,
                   requestResponse: requestResponse)
    }
    
    /**
     Initializes a new message from an encoded payload.
     
     The payload layout of the `payload` must be the following:
     [LIFX LAN Docs](https://lan.developer.lifx.com/docs/information-messages#lightstate---packet-107):
     
     ```
                                     1  1  1  1  1  1
       0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     | HUE | SAT | BRI | KEL | RES | POW |           |
     +--+--+--+--+--+--+--+--+--+--+--+--+           +
     |                                               |
     +                 LABEL             +--+--+--+--+
     |                                   |     RE-   |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |  SERVED   |                EMPTY              |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     
     HUE - hue
     SAT - saturation
     BRI - brightness
     KEL - kelvin
     RES - reserved
     POW - power
     ```
     
     - parameters:
        - source: Source identifier: unique value set by the client, used by responses.
        - target: `Target` of the `Message` indicating where the `Message` should be send to.
        - requestAcknowledgement: Indicates that a acknowledgement message is required.
        - requestResponse: Indicates that a response message is required.
        - sequenceNumber: Wrap around message sequence number.
        - payload: The encoded payload of the `LabelMessage`.
     */
    init(source: UInt32,
         target: Target,
         requestAcknowledgement: Bool,
         requestResponse: Bool,
         sequenceNumber: UInt8,
         payload: ByteBuffer) throws {
        guard payload.readableBytes >= 44 else {
            throw MessageError.messageFormat
        }
        
        
        guard let color = payload.getLIFXColor(at: payload.readerIndex, length: 12) else {
            throw ByteBufferError.notEnoughtBytes
        }
        self.color = color
        
        guard let label = payload.getString(at: payload.readerIndex, length: 32) else {
            throw ByteBufferError.notEnoughtBytes
        }
        self.label = label
        
        super.init(source: source,
                   target: target,
                   requestAcknowledgement: requestAcknowledgement,
                   requestResponse: requestResponse,
                   sequenceNumber: sequenceNumber)
    }
}
