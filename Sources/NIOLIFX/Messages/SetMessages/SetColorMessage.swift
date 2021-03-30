import NIO

/**
 SetColorMessage - 102
 
 Set a `ColorLight`'s color.
 */
class SetColorMessage: Message, SetMessage {
    typealias CorrespondingStateMessage = StateColorMessage
    
    override class var type: UInt16 {
        102
    }
    
    override class var responseTypes: [Message.Type] {
        super.responseTypes + [CorrespondingStateMessage.self]
    }
    
    
    let color: ColorLight.LIFXColor
    
    required init(_ state: ColorLight.State, target: Target) {
        self.color = state.color
        
        super.init(target: target,
                   requestAcknowledgement: false,
                   requestResponse: true)
    }
    
    /*
     Payload written in this write function:
     
     ```
                                     1  1  1  1  1  1
       0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
     +--+--+--+--+--+--+--+--+
     |        Reserved       |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                      HUE                      |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                   SATURATION                  |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                   BRIGHTNESS                  |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                     KELVIN                    |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     |                    DURATION                   |
     |                                               |
     +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     ```
     */
    override func writeData(inBuffer buffer: inout ByteBuffer) {
        buffer.writeInteger(UInt8(0))
        buffer.write(color: color)
        buffer.writeInteger(UInt32(0))
    }
}
