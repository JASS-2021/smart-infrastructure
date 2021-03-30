import NIO

/**
 StateColorMessage
 
 Message that carries a `LIFXColor` and a `Label` payload.
 */
final class StateColorMessage: Message {
    override class var type: UInt16 {
        107
    }
    
    let state: ColorLight.State
    
    /**
     Initializes a new message from an encoded payload.
     
     The payload layout of the `payload` must be the following:
     [LIFX LAN Docs](https://lan.developer.lifx.com/docs/information-messages#lightstate---packet-107):
     
     
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
        
        self.state = try payload.getState(at: payload.readerIndex).state
        
        super.init(source: source,
                   target: target,
                   requestAcknowledgement: requestAcknowledgement,
                   requestResponse: requestResponse,
                   sequenceNumber: sequenceNumber)
    }
}

extension StateColorMessage: StateMessage {
    static let content: KeyPath<StateColorMessage, ColorLight.State> = \.state
}
