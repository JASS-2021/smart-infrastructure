import NIO

/**
 SetColorMessage - 102
 
 Set a `ColorLight`'s color.
 */
class SetColorMessage: ColorMessage, SetMessage {
    typealias CorrespondingStateMessage = StateColorMessage
    
    override class var type: UInt16 {
        102
    }
    
    override class var responseTypes: [Message.Type] {
        super.responseTypes + [CorrespondingStateMessage.self]
    }
    
    required init(_ value: ColorLight.Color, target: Target) {
        super.init(target: target,
                   requestAcknowledgement: false,
                   requestResponse: true,
                   color: value)
    }
}
