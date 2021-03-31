import NIOLIFX


enum ColorLightState: String, Codable {
    case green
    case yellow
    case red
    case standby
    case other
    
    
    var color: NIOLIFX.ColorLight.LIFXColor {
        switch self {
        case .green:
            return NIOLIFX.ColorLight.LIFXColor.green
        case .yellow:
            return NIOLIFX.ColorLight.LIFXColor.yellow
        case .red:
            return NIOLIFX.ColorLight.LIFXColor.red
        case .standby:
            return NIOLIFX.ColorLight.LIFXColor.standby
        case .other:
            return NIOLIFX.ColorLight.LIFXColor.standby
        }
    }
    
    
    init(_ color: NIOLIFX.ColorLight.LIFXColor) {
        switch color {
        case .green:  self = .green
        case .yellow: self = .yellow
        case .red:    self = .red
        case .standby: self = .standby
        default: self = .other
        }
    }
}
