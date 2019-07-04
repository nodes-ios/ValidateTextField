// MARK: - ContentType

public extension ValidateTextField {
    
    enum State: Int {
        case error
        case normal
        case active
    }
    
    enum AssistiveViewPosition {
        case none 
        case outsideField(verticalAllignment: OFVerticalAlligment,
            horizontalAlligment: OFHorizontalAlligment)
        case insideField(verticalAllignment: IFVerticalAlligment,
            horizontalAlligment: IFHorizontalAlligment)
        
        public enum OFVerticalAlligment {
            case above
            case below
        }
        
        public enum OFHorizontalAlligment {
            case left
            case center
            case right
        }
        
        public enum IFVerticalAlligment {
            case top
            case center
            case bottom
        }
        
        public enum IFHorizontalAlligment {
            case right
        }
    }
}

public extension ValidateTextField {
    typealias ValidateConfiguration = [ValidateTextField.Configuration.Key: Any]
    
    enum Configuration {
        public enum Key: String {
            // overall view properties
            /**
             background color
             */
            case backgroundColor
            case spacing
            
            // header properties
            case headerOffFocusTextColor
            case headerInFocusTextColor
            case headerTextFont
            case headerText
            
            // text
            case textColor
            case textFont
            case text
            case tintColor
            
            // placeholder
            case placeholderTextColor
            case placeholderTextFont
            case placeholderText
            
            // error
            case errorTextColor
            case errorTextFont

            // assitive
            case assistiveTextColor
            case assistiveTextFont
            case assistiveText
            
            // layer and positioning
            case contentMargins
            case cornerRadius
            case borderWidth
            case borderOffFocusColor
            case borderInFocusColor
            case errorBorderColor
        }
    }
}
