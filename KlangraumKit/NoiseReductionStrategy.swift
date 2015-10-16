//
//  NoiseReductionStrategy.swift
//  GPB-Klangraum
//
//  Created by pascal on 15.10.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//

class AverageNoiseMagnitude {
    static let sharedInstance = AverageNoiseMagnitude()

    var anm:Float = 0.0

    private init() {}
}

public class NoiseReductionStrategy: FilterStrategy {

    public init() {}
    /**
    gets the average Magnitude at the Begin of audio and use spectral substraction to reduce 
    noise 
    
    :param: x:[Float] -> FFT-Samples 
    
    :returns: filtered FFT-Samples
    */
    public func apply(x: [Float]) -> [Float] {
        var result = [Float]()

        let noise = averageNoiseMagnitudes(x)

        for value in x {
            result.append(abs(value - noise.anm))
        }

        return result
    }

    func averageNoiseMagnitudes(x:[Float]) -> AverageNoiseMagnitude {
        let noise = AverageNoiseMagnitude.sharedInstance
        noise.anm = (sum(x) / Float(x.count))
        return noise
    }


}
