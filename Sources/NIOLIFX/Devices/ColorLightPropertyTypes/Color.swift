/**
 An object that stores color data and opacity (alpha value).
 */
struct Color: Equatable {
    /**
     The red component of the `Color` object.
     
     Values between 0.0 and 1.0 are inside the sRGB color gamut.
     */
    let red: Double
    
    /**
     The green component of the `Color` object.
     
     Values between 0.0 and 1.0 are inside the sRGB color gamut.
     */
    let green: Double
    
    /**
     The blue component of the `Color` object.
     
     Values between 0.0 and 1.0 are inside the sRGB color gamut.
     */
    let blue: Double
    
    /**
     The opacity component of the `Color` object.
     
     Specified as a value between 0.0 and 1.0.
     */
    let alpha: Double
    
    /**
     The hue component of the `Color` object.
     
     Values between 0.0 and 360.0 are inside the sRGB color gamut.
     */
    var hue: Double {
        Color.converte(red: red, green: green, blue: blue).hue
    }
    
    /**
     The saturation component of the `Color` object.
     
     Values between 0.0 and 1.0 are inside the sRGB color gamut.
     */
    var saturation: Double {
        Color.converte(red: red, green: green, blue: blue).saturation
    }
    
    /**
     Brightness component of the `Color` object.
     
     Values between 0.0 and 1.0 are inside the sRGB color gamut.
     */
    var brightness: Double {
        Color.converte(red: red, green: green, blue: blue).brightness
    }
    
    /**
     Initializes a new `Color` object.
     Values for `red`, `green`, and `blue` between 0.0 and 1.0 are inside the sRGB color gamut.
     Values for `alpha` smaller then 0.0 are interpeted as 0.0, values greater then 1.0 are interpeted as 1.0.
     
     - parameters:
        - red: The red component of the `Color` object.
        - green: The green component of the `Color` object.
        - blue: The blue component of the `Color` object.
        - alpha: The opacity component of the `Color` object.
     */
    init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = min(1.0, max(alpha, 0.0))
    }
    
    /**
     Initializes a new `Color` object.
     Values for `hue` must be between 0.0 and 260.0 to be inside the sRGB color gamut.
     Values for `saturation`, and `brightness` must be between 0.0 and 1.0 to be inside the sRGB color gamut.
     Values for `alpha` smaller then 0.0 are interpeted as 0.0, values greater then 1.0 are interpeted as 1.0.
     
     - parameters:
        - hue: The hue component of the `Color` object.
        - saturation: The saturation component of the `Color` object.
        - brightness: The brightness component of the `Color` object.
        - alpha: The opacity component of the `Color` object.
     */
    init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1.0) {
        (self.red, self.green, self.blue) = Color.converte(hue: hue, saturation: saturation, brightness: brightness)
        self.alpha = min(1.0, max(alpha, 0.0))
    }
    
    /**
     Converts a RGB color representation into a HSB representation.
     
     - parameters:
        - red: The red component
        - green: The green component.
        - blue: The blue component.
     - returns: The HSB representation.
     */
    private static func converte(red: Double, green: Double, blue: Double) -> (hue: Double, saturation: Double, brightness: Double) {
        let min = Swift.min(red, green, blue)
        let max = Swift.max(red, green, blue)
        
        let delta = max - min
        
        var hue: Double = 0
        if delta != 0 {
            if red == max {
                hue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6)
            } else if green == max {
               hue = 2 + (blue - red) / delta
            } else {
                hue = 4 + (red - green) / delta
            }
            
            hue *= 60
            if hue < 0 {
               hue += 360
            }
        }
        
        let saturation = max == 0 ? 0 : (delta / max)
        let brightness = (min + max) / 2
        
        return (hue, saturation, brightness)
    }
    
    /**
     Converts a RGB color representation into a HSB representation.
     
     - parameters:
        - hue: The hue component.
        - saturation: The saturation component.
        - brightness: The brightness component.
     - returns: The RGB representation.
     */
    private static func converte(hue: Double, saturation: Double, brightness: Double) -> (red: Double, green: Double, blue: Double) {
        let component1 = (1.0 - abs((2.0 * brightness) - 1.0)) * saturation
        let component2 = component1 * (1.0 - abs(abs((hue * 6.0).truncatingRemainder(dividingBy: 2.0)) - 1.0))
        let delta = brightness - (component1 / 2.0)
        
        switch hue {
        case ..<(1.0 / 6.0):
            return (component1 + delta, component2 + delta, delta)
        case (1.0 / 6.0)..<(2.0 / 6.0):
            return (component2 + delta, component1 + delta, delta)
        case (2.0 / 6.0)..<(3.0 / 6.0):
            return (delta, component1 + delta, component2 + delta)
        case (3.0 / 6.0)..<(4.0 / 6.0):
            return (delta, component2 + delta, component1 + delta)
        case (4.0 / 6.0)..<(5.0 / 6.0):
            return (component2 + delta, delta, component1 + delta)
        case (5.0 / 6.0)...:
            return (component1 + delta, delta, component2 + delta)
        default: fatalError("Unexpected behaviour, `hue` did not match any case,")
        }
    }
}
