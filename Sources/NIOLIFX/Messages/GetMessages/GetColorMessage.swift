/**
 GetColorMessage - 101
 
 Get device color. No payload is required. Causes the device to transmit a `StateColorMessage`.
 */
class GetPowerMessage: GetMessage<StateColorMessage> {
    override class var type: UInt16 {
        101
    }
}
