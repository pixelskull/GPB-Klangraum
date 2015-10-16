//
//  PlayerViewController.swift
//  GPB-Klangraum
//
//  Created by Alex on 05.10.15.
//  Copyright © 2015 Pascal Schönthier. All rights reserved.
//

import UIKit
import KlangraumKit
import AVFoundation

extension UIAlertController {
    
    class func alertControllerWithTitle(title:String, message:String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        return controller
    }  
}

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet var playPauseButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!

    private let samplingRate = 44100
    private let n = 1024

    private var player = AVAudioPlayer()
    
    var minFrequency: Float?
    var maxFrequency: Float?
    
    var mappedSamples: [Float]? { didSet { playPauseButton.enabled = true } }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.startAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        minFrequency = Float(2070)
//        maxFrequency = Float(2100)

        self.playPauseButton.enabled = false

        let audioFile = AudioFile()
        let url = NSBundle.mainBundle().bundleURL
        let filename = "pascal.m4a"
        
        guard let data = audioFile.readAudioFileToFloatArray(String(url.URLByAppendingPathComponent(filename))) else {
            let alert = UIAlertController.alertControllerWithTitle("Fehler", message: "Die Datei \(filename) konnte nicht geladen werden.")
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard let min = minFrequency, max = maxFrequency else {
            let alert = UIAlertController.alertControllerWithTitle("Fehler", message: "Es wurden keine Frequenzen übergeben.")
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        dispatch_async(dispatch_get_global_queue(Int(DISPATCH_QUEUE_PRIORITY_BACKGROUND), 0)) { [unowned self] in
            let length = self.n / 2
            
            let maxIndex = (length * Int(max)) / (self.samplingRate / 2 )
            let minIndex = (length * Int(min)) / (self.samplingRate / 2 )
            
            let padded = addZeroPadding(data, whileModulo: self.n)
            let window: [Float] = hamming(padded.count)
            let windowedData = window * padded
            let prepared = prepare(windowedData, steppingBy: self.n)
            
            let result = prepared.flatMap { samples -> [Float] in
                let f = FFT(initWithSamples: samples, andStrategy: [NoiseReductionStrategy(), AverageMappingStrategy(minIndex: minIndex, andMaxIndex: maxIndex)])
                return f.forward() --> f.applyStrategy --> f.inverse
            }
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.mappedSamples = result / window
                
                if self.activityIndicator.isAnimating() { self.activityIndicator?.stopAnimating() }
                
                let alert = UIAlertController.alertControllerWithTitle("Fertig", message: "Wir haben krassen shit gemacht!")
                self.presentViewController(alert, animated: true, completion: nil)

                let mappedFilePath = audioFile.safeSamples(self.mappedSamples!, ToPath: NSBundle.mainBundle().resourcePath! + "/mappedFile.caf")
                if let path = mappedFilePath {
                    self.prepareAudioPlayer(path)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareAudioPlayer(audioPath:String) {
        if let url = NSURL(string: audioPath) {
            do {
                self.player = try AVAudioPlayer(contentsOfURL: url)
            } catch let error as NSError {
                print("error occurred while preparing AudioPlayer \(error)")
                return
            }
            self.player.delegate = self
            self.player.prepareToPlay()
        }
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        let alert = UIAlertController.alertControllerWithTitle("Abgespielt", message: "Das war alles....")
        self.presentViewController(alert, animated: true, completion: nil)

        let buttonType = UIBarButtonSystemItem.Play
        setToolbarWithBarButtonSystemItem(buttonType)
    }

    func setToolbarWithBarButtonSystemItem(buttonType:UIBarButtonSystemItem) {
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: buttonType, target: self, action: "playPauseButtonAction:"),
            UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil)]
    }

    @IBAction func playPauseButtonAction(sender: UIBarButtonItem) {
        var buttonType:UIBarButtonSystemItem
        if self.player.playing {
            buttonType = UIBarButtonSystemItem.Play
            self.player.pause()
        } else {
            buttonType = UIBarButtonSystemItem.Pause
            self.player.volume = 1.0
            self.player.play()
        }
        setToolbarWithBarButtonSystemItem(buttonType)
    }


}
