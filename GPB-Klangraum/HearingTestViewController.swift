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
    
    let toneWidget = ToneWidget(channelNumber: 0, frame: CGRectZero)
    let soundGenerator = SoundGenerator()

}

struct Constants {
    static let width = 220
    static let numInstruments = 1
    static let frequencyScale: Float = 22000
}