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
import KlangraumKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {


        /**
            Create dummy-AudioFile
        **/
        let count:Int = 44100 * 3 // samplerate * seconds?!
        let frequency:Float = 4.0
//        let amplitude:Float = 3.0


//        var x:[Float] = map(0..<count){ 2.0 * Float(M_PI) / Float(count) * Float($0) * frequency }

        var test:UnsafeMutablePointer<Void> = UnsafeMutablePointer<Void>(sin(map(0..<count){ 2.0 * Float(M_PI) / Float(count) * Float($0) * frequency }))

        var buffer:AudioBufferList = AudioBufferList()
        buffer.mNumberBuffers = 1
        buffer.mBuffers.mNumberChannels = 1
        buffer.mBuffers.mDataByteSize = UInt32(count)
        buffer.mBuffers.mData = test

        let newFilePath: String = NSBundle.mainBundle().resourcePath! + "/dummy.caf"
//        let fileManager = NSFileManager.defaultManager()
//        fileManager.createFileAtPath(newFilePath, contents: nil, attributes: nil)

        var newFileDesc: AudioStreamBasicDescription = AudioStreamBasicDescription()
        newFileDesc.mSampleRate = 44100
        newFileDesc.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
        newFileDesc.mFormatFlags = AudioFormatFlags(kAudioFormatFlagIsFloat)
        newFileDesc.mChannelsPerFrame = 1
        newFileDesc.mBitsPerChannel = 32
        newFileDesc.mBytesPerFrame = 4
        newFileDesc.mFramesPerPacket = 1
        newFileDesc.mBytesPerPacket = newFileDesc.mFramesPerPacket * newFileDesc.mBytesPerFrame

        var urlRef:NSURL = NSURL(string: newFilePath)!

        var extAudio: ExtAudioFileRef = ExtAudioFileRef()
        ExtAudioFileCreateWithURL(urlRef, AudioFileTypeID(kAudioFileCAFType), &newFileDesc, nil, UInt32(kAudioFileFlags_EraseFile), &extAudio)

        var wErr = noErr

        wErr = ExtAudioFileWrite(extAudio, UInt32(count), &buffer)


        /*
            ExtAudioFile
        */
        println("start reading file")
        var err:OSStatus = noErr

//        let filePath:String = NSBundle.mainBundle().resourcePath!+"/YellowNintendoHero-Muciojad.mp3"
//        let filePath:String = NSBundle.mainBundle().resourcePath!+"/Test.m4a"
        let filePath:String = newFilePath

        let audioURL: NSURL = NSURL(string: filePath)!

        var audioFile: AudioFileID = nil
        var hint: AudioFileTypeID = 0

        err = AudioFileOpenURL(audioURL, Int8(kAudioFileReadPermission), hint, &audioFile)
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
//            var dstForm:AudioStreamBasicDescription = AudioStreamBasicDescription()
//            dstForm.mSampleRate = 44100
//            dstForm.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
//            dstForm.mFormatFlags = AudioFormatFlags(kAudioFormatFlagIsFloat)
//            dstForm.mBitsPerChannel = 32
//            dstForm.mChannelsPerFrame = 2
//            dstForm.mBytesPerFrame = dstForm.mChannelsPerFrame * 2
//            dstForm.mFramesPerPacket = 1
//            dstForm.mBytesPerPacket = dstForm.mFramesPerPacket * dstForm.mBytesPerFrame
//
//            err = noErr
//            err = ExtAudioFileSetProperty(audioFileRef, ExtAudioFilePropertyID(kExtAudioFileProperty_ClientDataFormat), UInt32(sizeof(AudioStreamBasicDescription)), &dstForm)

            var numberOfFrames:UInt32 = UInt32(count) // 512
            var data:NSMutableData = NSMutableData(length: Int(numberOfFrames)*sizeof(Float32))!

            // prepare AudioBufferlist
            var audioBufferList: AudioBufferList = AudioBufferList()
            audioBufferList.mNumberBuffers = 1
            audioBufferList.mBuffers.mData = data.mutableBytes
            audioBufferList.mBuffers.mDataByteSize = UInt32(data.length)
            audioBufferList.mBuffers.mNumberChannels = 2

            // read File
            do {
                if numberOfFrames <= UInt32(data.length / sizeof(Float32)) {
                    println("numberOfFrames <= \(data.length / sizeof(Float32)) \(numberOfFrames)")
                } else {
                    println("do something with Readdata ....")
                }

                println("numberOfFrames: \(numberOfFrames)")
                err = ExtAudioFileRead(audioFileRef, &numberOfFrames, &audioBufferList)

                if err != noErr {
                    break
                }
            } while numberOfFrames != 0

//            println(data)


            /**
                Converting Data to Float Array
            **/
            var count = data.length / sizeof(Float32)
            var array = [Float32](count: count, repeatedValue: 0.0)
            data.getBytes(&array, length: data.length)
//            println(array)
            // remove zero-values

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

