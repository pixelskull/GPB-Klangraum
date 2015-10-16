//
//  ViewController.swift
//  GPB-Klangraum
//
//  Created by pascal on 28/07/15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import UIKit
import KlangraumKit

class HearingTestViewController: UIViewController {
    
    private struct Storyboard {
        static let SegueIdentifier = "Show Player Identifier"
    }
    
    private var nsTimer: NSTimer?
    
    var toneWidgets = [ToneWidget]()
    let soundGenerator = SoundGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundGenerator.setUp()
        
        for i in 0 ..< Constants.numInstruments {
            let toneWidget = ToneWidget(channelNumber: i, frame: CGRectZero)
            
            toneWidget.addTarget(self, action: "toneWidgetChangeHandler:", forControlEvents: UIControlEvents.ValueChanged)
            
            toneWidgets.append(toneWidget)
            view.addSubview(toneWidget)
        }
    }
    
    @IBAction func start(sender: UIBarButtonItem) {
        guard let toneWidget = toneWidgets.first where Constants.numInstruments == 1 else { return }
        
        soundGenerator.playNoteOn(toneWidget.getFrequencyAmplitudePair(), channelNumber: 0)

        nsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0 / Double(Constants.frequencyScale * 60), target: self, selector: Selector("increase"), userInfo: nil, repeats: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("stop"), name: Constants.StopToneGeneratorNotification, object: nil)
    }
    
    func stop() {
        if let timer = nsTimer {
            timer.invalidate()
        }
        
        soundGenerator.stop()
        navigationItem.rightBarButtonItem?.enabled = true
    }
    
    func increase() {
        toneWidgets.first?.getFrequencyDial().currentValue += 1.0 / Float(Constants.frequencyScale / 10)
        toneWidgets.first?.dialChangeHander()
    }
    
    func toneWidgetChangeHandler(toneWidget: ToneWidget) {
        updateSineWave()
        
        soundGenerator.playNoteOn(toneWidget.getFrequencyAmplitudePair(), channelNumber: toneWidget.getChannelNumber())
    }
    
    func updateSineWave() {
        var values = [FrequencyAmplitudePair]()
        
        for widget in toneWidgets {
            values.append(widget.getFrequencyAmplitudePair())
        }
    }
    
    override func viewDidLayoutSubviews() {
        let columWidth = view.frame.width / CGFloat(Constants.numInstruments)
        let targetY = view.frame.height - 625 + topLayoutGuide.length
        
        for (i, toneWidget): (Int, ToneWidget) in toneWidgets.enumerate() {
            let targetX = CGFloat(i) * columWidth + (columWidth / 2) - CGFloat(Constants.width / 2)
            
            toneWidget.frame = CGRect(x: targetX, y: targetY, width: CGFloat(Constants.width), height: 625)
        }
        
        updateSineWave()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
            case Storyboard.SegueIdentifier:
                if let dvc = segue.destinationViewController as? PlayerViewController {
                    dvc.minFrequency = NSUserDefaults.standardUserDefaults().floatForKey(Constants.minFrequency)
                    dvc.maxFrequency = NSUserDefaults.standardUserDefaults().floatForKey(Constants.maxFrequency)
                }
            default: break
        }
    }
}

struct Constants {
    static let StopToneGeneratorNotification = "stopToneGeneratorNotification"
    
    static let maxFrequency = "maxFrequency"
    static let minFrequency = "minFrequency"
    
    static let amplitude: Float = 0.25
    static let width = 200
    static let numInstruments = 1
    static let frequencyScale: Float = 22000
}