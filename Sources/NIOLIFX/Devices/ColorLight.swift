import NIO

/**
 A `ColorLight` that can light up in a `Color` and color temperature.
 A `ColorLight` also allows users to execute `Effect`s on the `ColorLight`.
 */
public class ColorLight: Device {
    /**
     The `LIFXColor` the `ColorLight` lights up with.
     */
    public private(set) lazy var state: FutureValue<State> = {
        FutureValue(using: deviceManager, withAddress: address, andGetMessage: GetColorMessage.self)
    }()
    
    /**
     The `Effect` that the `ColorLight` currently displays.
     */
    let currentEffect: Effect? = nil
    
    /**
     Set the color of the `ColorLight`.
     */
    public func set(lifxColor: LIFXColor) -> EventLoopFuture<State> {
        let state = ColorLight.State(color: lifxColor, powerLevel: .enabled, label: "")
        
        let promise: EventLoopPromise<State> = deviceManager.eventLoop.makePromise()
        
        deviceManager.triggerUserOutboundEvent(SetColorMessage(state, target: Target(address))) { message in
            if let message = message as? SetColorMessage.CorrespondingStateMessage {
                self.state.wrappedValue = message[keyPath: SetColorMessage.CorrespondingStateMessage.content]
                promise.succeed(message[keyPath: SetColorMessage.CorrespondingStateMessage.content])
            }
        }
        
        let timeoutTask = deviceManager.eventLoop.scheduleTask(in: LIFXDeviceManager.Constants.lifxTimout) {
            promise.fail(ChannelError.connectTimeout(LIFXDeviceManager.Constants.lifxTimout))
        }
        
        promise.futureResult.whenComplete { _ in
            timeoutTask.cancel()
        }
        
        return promise.futureResult
    }
}
