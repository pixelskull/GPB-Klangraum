//
//  SoundGenerator.swift
//
//  Simon Gladman Jan 2015
//
//  Uses http://audiokit.io/

import Foundation

class SoundGenerator : NSObject {
    var oscillators = [Synth]()
    
    final func setUp() {
        for _ in 0 ..< Constants.numInstruments {
            let synth = Synth()
            AKOrchestra.addInstrument(synth)
            
            oscillators.append(synth)
        }
        
        AKOrchestra.start()
        
        for oscillator in oscillators {
            oscillator.play()
        }
    }
    
    final func playNoteOn(value: FrequencyAmplitudePair, channelNumber: Int) {
        let scaledFrequency = 0 + (value.frequency * Constants.frequencyScale)
        
        oscillators[channelNumber].amplitude.setValue(value.amplitude / 4.0, forKey: "value")
        
        oscillators[channelNumber].frequency.setValue(scaledFrequency, forKey: "value")
    }
    
    final func stop() {
        for oscillator in oscillators {
            oscillator.stop()
        }
    }
    
}


class Synth: AKInstrument {
    
    var frequency = AKInstrumentProperty(value: 0,  minimum: 0, maximum: Constants.frequencyScale)
    var amplitude = AKInstrumentProperty(value: 0,  minimum: 0, maximum: 0.25)
    
    override init() {
        super.init()
        
        let oscillator = AKOscillator()
        
        oscillator.frequency = frequency
        oscillator.amplitude = amplitude
        
        setAudioOutput(oscillator)
    }
}

