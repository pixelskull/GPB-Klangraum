//
//  AudioFileServices.swift
//  GPB-Klangraum
//
//  Created by pascal on 11/08/15.
//  Copyright (c) 2015 Pascal Schönthier. All rights reserved.
//

import CoreAudio
import AudioToolbox
import AVFoundation


public class AudioFileService {

    var bufferSize:Int
    var dataSize:Int

//    var audioFileProperty:Dictionary<String: Strings> = Dictionary<String: String>()

    public init() {
        bufferSize = 0
        dataSize = 0
    }

    /**
    Creates dummy audio with sinoid signal in linearPCM format

    :returns: Path (String) to new file or nil if file is not creatable
    */
    public func createDummyFile() -> String? {
        let count:Int = 44100 * 3 // samplerate * seconds?!
        self.dataSize = count
        let frequency:Float = 4.0
        let amplitude:Float = 3.0

        // generates Pointer to Float-array
        var x:UnsafeMutablePointer<Void> = UnsafeMutablePointer<Void>(sin(map(0..<count){ 2.0 * Float(M_PI) / Float(count) * Float($0) * frequency }))
        // create AudioBufferList with the Array-Pointer as Data
        var buffer:AudioBufferList = AudioBufferList()
        buffer.mNumberBuffers = 1
        buffer.mBuffers.mNumberChannels = 1
        buffer.mBuffers.mDataByteSize = UInt32(count)
        buffer.mBuffers.mData = x

        //create filepath of the new AudioFile
        let newFilePath: String = NSBundle.mainBundle().resourcePath! + "/dummy.caf"
        // make URL out of path
        var urlRef:NSURL = NSURL(string: newFilePath)!
        //create Basic description for the new AudioFile
        var newFileDesc: AudioStreamBasicDescription = AudioStreamBasicDescription()
        newFileDesc.mSampleRate = 44100
        newFileDesc.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
        newFileDesc.mFormatFlags = AudioFormatFlags(kAudioFormatFlagsNativeFloatPacked)
        newFileDesc.mChannelsPerFrame = 1
        newFileDesc.mBitsPerChannel = 32
        newFileDesc.mBytesPerFrame = 4
        newFileDesc.mFramesPerPacket = 1
        newFileDesc.mBytesPerPacket = newFileDesc.mFramesPerPacket * newFileDesc.mBytesPerFrame

        // create new AudioFile with Reference
        var extAudio: ExtAudioFileRef = ExtAudioFileRef()
        ExtAudioFileCreateWithURL(urlRef, AudioFileTypeID(kAudioFileCAFType), &newFileDesc, nil, UInt32(kAudioFileFlags_EraseFile), &extAudio)
        // write data to the empty Audio-file
        var wErr = noErr
        wErr = ExtAudioFileWrite(extAudio, UInt32(count), &buffer)

        if wErr == noErr {
            return newFilePath
        } else {
            return nil
        }
    }

    public func readAudioFileProperties(path: String) {
        let url:NSURL = NSURL(fileURLWithPath: path)!
        let player:AVAudioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)

        println(player.settings)
    }

    /**
    Reads samples from audiofile and return an AudioBufferList

    :param: path:String -> Path to audiofile

    :returns: AudioBufferList? with samples or nil if file not readable
    */
    public func readAudioFileToAudioBufferList(audioFilePath:String) -> AudioBufferList? {
        var err:OSStatus = noErr
        let audioURL: NSURL = NSURL(string: audioFilePath)! // make URL from path
        // create an empty fileID
        var audioFile: AudioFileID = nil
        var hint: AudioFileTypeID = 0
        err = AudioFileOpenURL(audioURL, Int8(kAudioFileReadWritePermission), hint, &audioFile)

        if (err == noErr) {
            // reading file-properties
            var outDataSize: UInt32 = 0
            var isWritable: UInt32 = 0
            err = AudioFileGetPropertyInfo(audioFile, UInt32(kAudioFilePropertyInfoDictionary), &outDataSize, &isWritable)

            var dict:NSDictionary?
            //        var key:AudioChannelLayout = AudioChannelLayout()
            err = noErr
            err = AudioFileGetProperty(audioFile , UInt32(kAudioFilePropertyInfoDictionary), &outDataSize, &dict)
            err = ExtAudioFileGetProperty(audioFile, UInt32(kExtAudioFileProperty_IOBufferSizeBytes), &outDataSize, &bufferSize)

            println(dict)
            println(bufferSize)

            // open audiofile
            var audioFileRef: ExtAudioFileRef = ExtAudioFileRef()
            err = noErr
            err = ExtAudioFileOpenURL(audioURL, &audioFileRef)

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

            var numberOfFrames:UInt32 = UInt32(512) // 512
            var data:NSMutableData = NSMutableData(length: Int(numberOfFrames)*sizeof(Float32))!

            // prepare AudioBufferlist
            var audioBufferList: AudioBufferList = AudioBufferList()
            audioBufferList.mNumberBuffers = 1
            audioBufferList.mBuffers.mData = data.mutableBytes
            audioBufferList.mBuffers.mDataByteSize = UInt32(data.length)
            audioBufferList.mBuffers.mNumberChannels = 2

            // read File
            do {
                if numberOfFrames < UInt32(data.length / sizeof(Float32)) {
//                    println("numberOfFrames < \(data.length / sizeof(Float32)) \(numberOfFrames)")
                } else {
//                    println("do something with Readdata ....")
                }
                err = ExtAudioFileRead(audioFileRef, &numberOfFrames, &audioBufferList)
                if err != noErr {
                    break
                }
            } while numberOfFrames != 0
            return audioBufferList
        } else {
            return nil
        }
    }

    /**
    converts data in an optional AudioBufferList to optional Array of Floats
    
    :param: bufferList:AudioBufferList? -> Optional-Value for AudioBufferList
    
    :param: length:Int -> length of the Data to read
    
    :returns: optional Array of Floats
    */
    public func convertAudioBufferListToFloatArray(bufferList:AudioBufferList?, length:Int) -> [Float32]? {
        if let audioBuffer:AudioBufferList = bufferList {
            var data:NSData = NSData(bytes: audioBuffer.mBuffers.mData, length: length)
            //        var count = 44100*3
            var array = [Float](count: length, repeatedValue: 0.0)
            data.getBytes(&array, length: length)
            
            return array
        } else {
            return nil
        }
    }

    /**
    converts audiofile in any Format to linear PCM 
    
    :param: path:String -> Path to the Audiofile you want to convert
    
    :returns: converted Audio-File as NSData
    */
    public func convertToLinearPCM(path:String) -> NSData? {
        //TODO: implement
        return self.convertToLinearPCM( self.readAudioFileToAudioBufferList(path)! )
    }

    /**
    converts audiofile in any Format to linear PCM

    :param: data:NSData -> NSData representing the Audiofile you want to convert

    :returns: converted Audio-File as NSData
    */
    public func convertToLinearPCM(audioBufferList:AudioBufferList) -> NSData? {
        //TODO: implement
        // optional set Audio Encoding to linearPCM dual-channel with Float-values
        var dstForm:AudioStreamBasicDescription = AudioStreamBasicDescription()
        dstForm.mSampleRate = 44100
        dstForm.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
        dstForm.mFormatFlags = AudioFormatFlags(kAudioFormatFlagIsFloat)
        dstForm.mBitsPerChannel = 32
        dstForm.mChannelsPerFrame = 2
        dstForm.mBytesPerFrame = dstForm.mChannelsPerFrame * 8
        dstForm.mFramesPerPacket = 1
        dstForm.mBytesPerPacket = dstForm.mFramesPerPacket * dstForm.mBytesPerFrame

        var err:OSStatus = noErr
        var audioFileRef:ExtAudioFileRef = ExtAudioFileRef()
        err = ExtAudioFileSetProperty(audioFileRef, ExtAudioFilePropertyID(kExtAudioFileProperty_ClientDataFormat), UInt32(sizeof(AudioStreamBasicDescription)), &dstForm)



        return NSData()
    }

    /**
    import Audio in diffrent formats so the App can work with the data
    */
    public func importAudio() {
        //TODO: implement
    }

}

