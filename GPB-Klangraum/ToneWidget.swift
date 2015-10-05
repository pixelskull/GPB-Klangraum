//
//  ToneWidget.swift
//  GPB-Klangraum
//
//  Created by Alex on 02.10.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//

import UIKit

class ToneWidget: UIControl {
    private let frequencyDial = NumericDial(frame: CGRectZero)
    //private let amplitudeDial = NumericDial(frame: CGRectZero)
    private let sineWaveRenderer = SineWaveRenderer(frame: CGRectZero)
    
    private let channelNumber: Int
    
    required init(channelNumber: Int, frame: CGRect)
    {
        self.channelNumber = channelNumber
        
        super.init(frame: frame)
        
        addSubview(sineWaveRenderer)
        addSubview(frequencyDial)
        //addSubview(amplitudeDial)
        
        frequencyDial.addTarget(self, action: "dialChangeHander", forControlEvents: UIControlEvents.ValueChanged)
        //amplitudeDial.addTarget(self, action: "dialChangeHander", forControlEvents: UIControlEvents.ValueChanged)
        
        frequencyDial.currentValue = 0.0
        //amplitudeDial.currentValue = 0.25
        
        dialChangeHander()
    }
    
    func getChannelNumber() -> Int
    {
        return channelNumber
    }
    
    func getFrequencyDial() -> NumericDial {
        return frequencyDial
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getFrequencyAmplitudePair() -> FrequencyAmplitudePair
    {
        return FrequencyAmplitudePair(frequency: frequencyDial.currentValue, amplitude: Constants.amplitude)
    }
    
    func dialChangeHander()
    {
        sineWaveRenderer.setFrequencyAmplitudePairs([getFrequencyAmplitudePair()])
        
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    override func didMoveToWindow()
    {
        sineWaveRenderer.frame = CGRect(x: 0, y: 0, width: Constants.width, height: 125)
        frequencyDial.frame = CGRect(x: 0, y: 145, width: Constants.width, height: Constants.width)
        //amplitudeDial.frame = CGRect(x: 0, y: 355, width: Constants.width, height: Constants.width)
        
        frequencyDial.labelFunction = frequencyLabelFunction
        //amplitudeDial.labelFunction = amplitudeLabelFunction
        
        sineWaveRenderer.setFrequencyAmplitudePairs([getFrequencyAmplitudePair()])
    }
    
    func frequencyLabelFunction(value: Float) -> String
    {
        let valueAsString = NSString(format: "%d", Int(value * Constants.frequencyScale))
        return "Frequency\n\(valueAsString)"
    }
    
    func amplitudeLabelFunction(value: Float) -> String
    {
        let valueAsString = NSString(format: "%.4f", value)
        return "Amplitude\n\(valueAsString)"
    }
}