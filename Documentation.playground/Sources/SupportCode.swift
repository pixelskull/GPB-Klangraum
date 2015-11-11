//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to TestingPlayground.playground.
//

import UIKit

public class ToneWidget: UIControl {
    
    public var currentValue: Float = 1.0
    
    public init(channelNumber: Int, frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getFrequencyAmplitudePair() -> FrequencyAmplitudePair {
        return FrequencyAmplitudePair()
    }
    
    public func dialChangeHander() { }
}

public class SoundGenerator {

    public init() {}
    
    public func setUp() {}
    
    public func playNoteOn(value: FrequencyAmplitudePair, channelNumber: Int) { }
    
    public func stop() {}
}

public struct FrequencyAmplitudePair { }