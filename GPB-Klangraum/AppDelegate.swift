//
//  AppDelegate.swift
//  GPB-Klangraum
//
//  Created by pascal on 28/07/15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import UIKit

import AudioToolbox
import CoreAudio

import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?

    var audioPlayer:AVAudioPlayer = AVAudioPlayer()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

       /*
            ExtAudioFile
        */
        println("start reading file")
        var err:OSStatus = noErr

        let filePath:String = NSBundle.mainBundle().resourcePath!+"/YellowNintendoHero-Muciojad.mp3"
        let audioURL: NSURL = NSURL(fileURLWithPath: filePath)!

        var audioFile: AudioFileID = nil
        var hint: AudioFileTypeID = 0

        err = AudioFileOpenURL(audioURL, Int8(kAudioFileReadWritePermission), hint, &audioFile)
        println(err)

        if (err == noErr) {

            // reading file-properties
            var outDataSize: UInt32 = 0
            var isWritable: UInt32 = 0
            err = AudioFileGetPropertyInfo(audioFile, UInt32(kAudioFilePropertyInfoDictionary), &outDataSize, &isWritable)
            println(err)
            println(outDataSize)

            var dict:NSDictionary?
            var key:AudioChannelLayout = AudioChannelLayout()
            err = AudioFileGetProperty(audioFile , UInt32(kAudioFilePropertyInfoDictionary), &outDataSize, &key)

            println(err)
            println("Dictionary: \(key.mChannelBitmap)")


            err = noErr

            // open audiofile
            var audioFileRef: ExtAudioFileRef = ExtAudioFileRef()
            err = ExtAudioFileOpenURL(audioURL, &audioFileRef)

            println(err)

            // optional set Audio Encoding to linearPCM dual-channel with Float-values
            var dstForm:AudioStreamBasicDescription = AudioStreamBasicDescription()
            dstForm.mSampleRate = 44100
            dstForm.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
            dstForm.mFormatFlags = AudioFormatFlags(kAudioFormatFlagIsFloat)
            dstForm.mBitsPerChannel = 32
            dstForm.mChannelsPerFrame = 2
            dstForm.mBytesPerFrame = dstForm.mChannelsPerFrame * 2
            dstForm.mFramesPerPacket = 1
            dstForm.mBytesPerPacket = dstForm.mFramesPerPacket * dstForm.mBytesPerFrame

            err = noErr
            err = ExtAudioFileSetProperty(audioFileRef, ExtAudioFilePropertyID(kExtAudioFileProperty_ClientDataFormat), UInt32(sizeof(AudioStreamBasicDescription)), &dstForm)

            var numberOfFrames:UInt32 = 512
            var data:NSMutableData = NSMutableData(length: Int(numberOfFrames)*sizeof(Float32))!

            // prepare AudioBufferlist
            var audioBufferList: AudioBufferList = AudioBufferList()
            audioBufferList.mNumberBuffers = 1
            audioBufferList.mBuffers.mData = data.mutableBytes
            audioBufferList.mBuffers.mDataByteSize = UInt32(data.length)
            audioBufferList.mBuffers.mNumberChannels = 2

            // read File
            do {
                err = ExtAudioFileRead(audioFileRef, &numberOfFrames, &audioBufferList)
                if err != noErr {
                    break
                } else if numberOfFrames <= UInt32(data.length / sizeof(Float32)) {
                    println("numberOfFrames <= \(data.length / sizeof(Float32)) \(numberOfFrames)")
                } else {
                    println("do something with Readdata ....")
                }
            } while numberOfFrames != 0

            println(data)


            /**
                Converting Data to Float Array
            **/
            var count = data.length / sizeof(Float32)
            var array = [Float32](count: count, repeatedValue: 0.0)
            data.getBytes(&array, length: data.length)
            println(array)
            // remove zero-values
            array = array.filter({ i in return i != 0.0})
            println(array)

        } else {
            println("error: \(err)")
        }

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

