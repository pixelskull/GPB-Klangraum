//
//  AppDelegate.swift
//  GPB-Klangraum
//
//  Created by pascal on 28/07/15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import UIKit
import KlangraumKit

import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let samplingRate = 44100
        let n = 1024
        let audioFile = AudioFile()

        let url = NSBundle.mainBundle().bundleURL
        if let data = audioFile.readAudioFileToFloatArray(String(url.URLByAppendingPathComponent("YellowNintendoHero-Muciojad.mp3"))) {

            let max = 800
            let min = 100

//            let maxIndex = /*(n) * min / (samplingRate / 2)*/  max / 2 
//            let minIndex = /*(n) * max / (samplingRate / 2)*/  min / 2

            let length = n / 2
//            var j = 0
            var full = [[Float]](count: length, repeatedValue: [0.0])

            //    for i in 0..<length {
            //        let first = j*n
            //        let last = (j+1) * n
            //        full[i] = Array(data[first..<last])
            //        j++
            //    }

            full[0] = Array(data[0*n..<(0+1)*n])


            let a = FFT(initWithSamples: full[0], andStrategy: [MappingStrategy(minIndex: min, and: max)])
            let b = a.forward()
//            plot(magnitudes(b), "original")
            print(magnitudes(b))

            let c = a.applyStrategy(b)
            print(magnitudes(c))
//            plot(magnitudes(c), "strategy")

        }


//        var audioFile:AudioFile = AudioFile()
//
//        let aPath:String = audioFile.createDummyFile().dematerialize()!
////        println(aPath)
//
//        let convertPath = audioFile.convertFileToLinearPCMFormat(NSBundle.mainBundle().pathForResource("YellowNintendoHero-Muciojad", ofType: "mp3")!)
//
//        println("-----")
//
//        
//        let audioPath:String = NSBundle.mainBundle().pathForResource("YellowNintendoHero-Muciojad", ofType: "mp3")!
//
//        /*audioFile.openAudioFile(audioPath) --> audioFile.convertToLinearPCM -->*/
//        let path = audioFile.safeSamples([0.0], ToPath: NSBundle.mainBundle().resourcePath! + "/dummy2.caf")
//
//        let result:[String:[Float]]? = audioFile.readAudioFileToSplitFloatArray(audioPath)
//        if let r = result {
//            println(r["left"]!.count)
//            println(r["right"]!.count)
//        }

        return true 
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

