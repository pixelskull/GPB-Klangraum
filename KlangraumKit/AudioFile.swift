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


public class AudioFile {

    public var fileProperty:[NSObject:AnyObject] = [NSObject:AnyObject]()

    public var audioFileData:NSData = NSData()
    public var dataSize:Int{
        get{
            return audioFileData.length
        }
    }

    public var audioBufferList:AudioBufferList = AudioBufferList()
    public var audioBufferSize:Int = 0

    public var player:AVAudioPlayer = AVAudioPlayer()

    public var sampleRate:Int{
        get{
            return self.fileProperty[AVSampleRateKey]!.integerValue
        }
    }

    public var audioPath:String = ""
    public var audioURL:NSURL{
        get{
            return NSURL(fileURLWithPath: audioPath)!
        }
    }

    public var audioDuration:NSTimeInterval = NSTimeInterval()

    /**
    initializer 
    
    :param: path:String -> path to audiofile
    */
    public init(path:String){ setupAudioFile(path) }

    public init() {
        let path = createDummyFile()
        if let p = path.dematerialize() {
            setupAudioFile(p)
        }
    }

    /**
    helpermethod for initializers
    
    :param: path:String -> path to audiofile
    */
    func setupAudioFile(path: String) {
        audioPath = path
        player = AVAudioPlayer(contentsOfURL: audioURL, error: nil)
        fileProperty = readAudioFileProperties()
        if let ab = readAudioFileToAudioBufferList(path).dematerialize() {
            audioBufferList = ab
        }
//        audioFileData = readAudioFileData()
        audioDuration = readAudioFileDuration()
    }

    /**
    Creates dummy audio with sinoid signal in linearPCM format

    :returns: Path (String) to new file or nil if file is not creatable
    */
    public func createDummyFile() -> Failable<String> {
        let count:Int = 44100 * 3 // samplerate * seconds?!
        var dataSize = count
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
            return Failable.Success(Box(newFilePath))
        } else {
            return Failable.Failure("dummyFile not created")
        }
    }

    /**
    get Audio in NSData-Format 
    
    :returns: data:NSData -> AudioData
    */
    func readAudioFileData() -> NSData { return player.data }

    /**
    get Audio Properties 
    
    :returns: Property Dictionary
    */
    func readAudioFileProperties() -> [NSObject:AnyObject] { return player.settings }

    /**
    reads duration of audio-file 
    
    :returns: duration:NSTimeInterval -> duration of Audio
    */
    func readAudioFileDuration() -> NSTimeInterval { return player.duration }

    /**
    Reads samples from audiofile and return an AudioBufferList

    :param: path:String -> Path to audiofile

    :returns: AudioBufferList? with samples or nil if file not readable
    */
    public func readAudioFileToAudioBufferList(audioFilePath:String) -> Failable<AudioBufferList> {
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
            err = ExtAudioFileGetProperty(audioFile, UInt32(kExtAudioFileProperty_IOBufferSizeBytes), &outDataSize, &audioBufferSize)

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
//                if numberOfFrames < UInt32(data.length / sizeof(Float32)) {
//                    println("numberOfFrames < \(data.length / sizeof(Float32)) \(numberOfFrames)")
//                } else {
//                    println("do something with Readdata ....")
//                }
                err = ExtAudioFileRead(audioFileRef, &numberOfFrames, &audioBufferList)
                if err != noErr {
                    break
                }
            } while numberOfFrames != 0
            return Failable.Success(Box(audioBufferList))
        } else {
            return Failable.Failure("no BufferList created")
        }
    }

    /**
    converts data in an optional AudioBufferList to optional Array of Floats
    
    :param: bufferList:AudioBufferList? -> Optional-Value for AudioBufferList
    
    :param: length:Int -> length of the Data to read
    
    :returns: optional Array of Floats
    */
    public func convertAudioBufferListToFloatArray(bufferList:AudioBufferList) -> Failable<[Float32]> {
        if (self.sampleRate > 0) {
            if self.audioDuration > 0.0 {
                var data:NSData = NSData(bytes: bufferList.mBuffers.mData, length: self.sampleRate * Int(self.audioDuration))
                //        var count = 44100*3
                var array = [Float](count: self.sampleRate * Int(self.audioDuration), repeatedValue: 0.0)
                data.getBytes(&array, length: self.sampleRate * Int(self.audioDuration))

                return Failable.Success(Box(array))
            } else {
                return Failable.Failure("audio duration was zero")
            }
        } else {
            return Failable.Failure("sample rate was zero")
        }
    }

    /**
    reads audio samples from self.audioPath as array of Floats
    
    :retruns: Failable<[Float32]> -> Failable Enum with sample array
    */
    public func readAudioFileAsFloatArray() -> Failable<[Float32]>{
        return self.readAudioFileToAudioBufferList(self.audioPath) -->  convertAudioBufferListToFloatArray
    }

    /**
    converts audiofile in any Format to linear PCM 
    
    :param: path:String -> Path to the Audiofile you want to convert
    
    :returns: converted Audio-File as NSData
    */
//    public func convertToLinearPCM(path:String) -> NSData {
//        //TODO: implement
//        return self.convertToLinearPCM( self.readAudioFileToAudioBufferList(path) )
//    }

    /**
    converts audiofile in any Format to linear PCM

    :param: data:NSData -> NSData representing the Audiofile you want to convert

    :returns: converted Audio-File as NSData
    */
    public func convertToLinearPCM(audioBufferList:AudioBufferList) -> Failable<NSData> {
        //TODO: implement
        // optional set Audio Encoding to linearPCM dual-channel with Float-values
        var dstForm:AudioStreamBasicDescription = AudioStreamBasicDescription()
        dstForm.mSampleRate = Float64(self.sampleRate)
        dstForm.mFormatID = AudioFormatID(kAudioFormatLinearPCM)
        dstForm.mFormatFlags = AudioFormatFlags(kAudioFormatFlagIsFloat)
        dstForm.mBitsPerChannel = 32
        dstForm.mChannelsPerFrame = 1
//        dstForm.mBytesPerFrame = dstForm.mChannelsPerFrame 
//        dstForm.mFramesPerPacket = 1
//        dstForm.mBytesPerPacket = dstForm.mFramesPerPacket * dstForm.mBytesPerFrame

        var err:OSStatus = noErr
        var audioFileRef:ExtAudioFileRef = ExtAudioFileRef()
        err = ExtAudioFileSetProperty(audioFileRef, ExtAudioFilePropertyID(kExtAudioFileProperty_ClientDataFormat), UInt32(sizeof(AudioStreamBasicDescription)), &dstForm)
        if err == noErr {
            //TODO: Implement
            return Failable.Success(Box(NSData()))
        } else {
            return Failable.Failure("No linearPCM conversion")
        }
    }

    /**
    import Audio in diffrent formats so the App can work with the data
    */
    public func importAudio() {
        //TODO: implement
    }

}

