//
//  MicController.m
//  WaveForm2
//
//  Created by alexanderbollbach on 2/11/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "AudioController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h>
#import "Global.h"

#define kOutputBus 0
#define kInputBus 1
#define kSampleRate 88200
#define kBufferDuration 0.01



@interface AudioController() {
   
   int index;
   int timeIndex;
   
   
   AudioUnit remoteIOUnit;
   
   
   
   
   
   float * samplesBuffer;
   
   float * effectsBuffer;

   
   
   
}

@property (nonatomic,assign) float bufferDuration;
@property (nonatomic,assign) int bufferIndex;

@property (nonatomic,strong)  Global * global;

@end

@implementation AudioController

+ (instancetype)sharedInstance {
   static dispatch_once_t once;
   static id sharedInstance;
   dispatch_once(&once, ^{
      sharedInstance = [[self alloc] init];
   });
   return sharedInstance;
}

- (instancetype)init {
   if (self = [super init]) {
      
      
      samplesBuffer = malloc(300000 * sizeof(float));
      effectsBuffer = malloc(500000 * sizeof(float));

      self.bufferDuration = kBufferDuration;
      
      self.global = [Global sharedInstance];
      
      [self initializeAudioSession];
      [self initializeAU];
      
      
      
    
      
      
   }
   return self;
}





#pragma mark - Audio Session -

- (void)initializeAudioSession {
   
   NSError *audioSessionError = nil;
   AVAudioSession *session = [AVAudioSession sharedInstance];
   
   // set category
   [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&audioSessionError];
   if (audioSessionError) {
      NSLog(@"Error %ld, %@",
            (long)audioSessionError.code, audioSessionError.localizedDescription);
   }
   
   // set preferred buffer duration
   [session setPreferredIOBufferDuration:self.bufferDuration error:&audioSessionError];
   if (audioSessionError) {
      NSLog(@"Error %ld, %@",
            (long)audioSessionError.code, audioSessionError.localizedDescription);
   }
   
   // set sample rate
   double sampleRate = kSampleRate; // I would prefer a sample rate of 44.1kHz
   [session setPreferredSampleRate:sampleRate error:&audioSessionError];
   if (audioSessionError) {
      NSLog(@"Error %ld, %@",
            (long)audioSessionError.code, audioSessionError.localizedDescription);
   }
   
   [[NSNotificationCenter defaultCenter] addObserver: self
                                            selector: @selector(handleRouteChange:)
                                                name: AVAudioSessionRouteChangeNotification
                                              object: session];
   // set ACtive
   [session setActive:YES error:&audioSessionError];
   if (audioSessionError) {
      NSLog(@"Error %ld, %@",
            (long)audioSessionError.code, audioSessionError.localizedDescription);
   }
   
   // Get current values
   sampleRate = session.sampleRate;
   self.bufferDuration = session.IOBufferDuration;
   NSLog(@"Sample Rate:%0.0fHz I/O Buffer Duration:%f", sampleRate, self.bufferDuration);
   
   
   printf("end of set session \n");
}

- (void)handleRouteChange:(NSNotification *)notification {
   printf("handle\n");
  // CheckError(, "Couldn't initialize input unit");
   

}


- (void)initializeAU {
   
   AudioComponentDescription iocd;
   iocd.componentType = kAudioUnitType_Output;
   iocd.componentSubType = kAudioUnitSubType_RemoteIO;
   iocd.componentManufacturer = kAudioUnitManufacturer_Apple;
   iocd.componentFlags = 0;
   iocd.componentFlagsMask = 0;
   AudioComponent ioComp = AudioComponentFindNext(NULL, &iocd);
   CheckError(AudioComponentInstanceNew(ioComp, &remoteIOUnit), "Couldn't get RIO unit instance");
   
   UInt32 oneFlag = 1; ///////////////////////////////   i/o
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioOutputUnitProperty_EnableIO,
                                   kAudioUnitScope_Output,
                                   kOutputBus,
                                   &oneFlag,
                                   sizeof(oneFlag)), "Couldn't enable RIO output");
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioOutputUnitProperty_EnableIO,
                                   kAudioUnitScope_Input,
                                   kInputBus,
                                   &oneFlag,
                                   sizeof(oneFlag)), "Couldn't enable RIO input");
   
   AudioStreamBasicDescription myASBD;  /////////////////////  stream
   memset (&myASBD, 0, sizeof(myASBD));
   myASBD.mSampleRate = kSampleRate;
   myASBD.mFormatID = kAudioFormatLinearPCM;
   myASBD.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked;
   myASBD.mChannelsPerFrame = 1;
   myASBD.mBitsPerChannel = 8 * sizeof(float);
   myASBD.mBytesPerFrame = sizeof(float) *  myASBD.mChannelsPerFrame;
   myASBD.mFramesPerPacket = 1 * myASBD.mChannelsPerFrame;
   myASBD.mBytesPerPacket = myASBD.mBytesPerFrame; // packet == frame
   self.streamFormat = myASBD;
   
   // stream on inscope of outToHardware (bus/element 0) and on outscope of inFromMic (bus/element 1)
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Input,
                                   kOutputBus,
                                   &myASBD,
                                   sizeof(myASBD)), "Couldn't set ASBD for RIO on input scope / bus 0");
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Output,
                                   kInputBus,
                                   &myASBD,
                                   sizeof(myASBD)), "Couldn't set ASBD for RIO on output scope / bus 1");
   
   
   
   
   UInt32 shouldAllocateBuffer = 1;
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioUnitProperty_ShouldAllocateBuffer,
                                   kAudioUnitScope_Input,
                                   0,
                                   &shouldAllocateBuffer,
                                   sizeof(shouldAllocateBuffer)), "should alloc");
   
   
   
   
   
  
   
   /////////////////////////////////////////////////// bufferlist
   UInt32 maxFrames = 0;
   UInt32 sizeOfMaxFrames = sizeof(maxFrames);
   CheckError( AudioUnitGetProperty(remoteIOUnit,
                                    kAudioUnitProperty_MaximumFramesPerSlice,
                                    kAudioUnitScope_Global,
                                    kOutputBus,
                                    &maxFrames,
                                    &sizeOfMaxFrames), "couldn't get maxFrame");
   
   // bufferCapacity = maxFrames;
   
   int offset = offsetof(AudioBufferList, mBuffers[0]);
   int bufferListSizeBytes = offset + (sizeof(AudioBuffer) * myASBD.mChannelsPerFrame);
   
   self.inputBuffer = malloc(bufferListSizeBytes);
   self.inputBuffer->mNumberBuffers = myASBD.mChannelsPerFrame;
   
   UInt32 bufferSizeBytes = maxFrames * sizeof(float);
   
   self.inputBuffer->mBuffers[0].mNumberChannels = 1;
   self.inputBuffer->mBuffers[0].mDataByteSize = bufferSizeBytes;
   self.inputBuffer->mBuffers[0].mData = malloc(bufferSizeBytes);
   
   
   
   
   
   
     AURenderCallbackStruct renderCallback;
   renderCallback.inputProc = playbackCallback;
   renderCallback.inputProcRefCon = (__bridge void * _Nullable)self;
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioUnitProperty_SetRenderCallback,
                                   kAudioUnitScope_Output,
                                   kOutputBus,
                                   &renderCallback,
                                   sizeof(renderCallback)), "Couldn't set input callback");
   
   
   
   
   //////// INITIALIZE RemoteIO
   CheckError(AudioUnitInitialize(remoteIOUnit), "Couldn't initialize input unit");

 
   OSStatus err = AudioOutputUnitStart(remoteIOUnit);

//   AudioOutputUnitStop(remoteIOUnit);
}












#pragma mark - remoteIO Playback -


OSStatus playbackCallback(void * inRefCon,
                          AudioUnitRenderActionFlags * ioActionFlags,
                          const AudioTimeStamp * inTimeStamp,
                          UInt32 inBusNumber,
                          UInt32 inNumberFrames,
                          AudioBufferList * ioData) {
   
   
   
   static int howMany = 0;
   howMany++;
   
   AudioController *THIS = (__bridge AudioController *)inRefCon;
   

   
   float * temp = ioData->mBuffers[0].mData;
   
   int start = (int)THIS.global.modeManager.mode1.param1.value;
   int end = (int)THIS.global.modeManager.mode1.param2.value;
   
   
   if (end < 0 || start < 0) return noErr;
   
  //  clear outside of start/end
   for (int x = 0;  x < start; x++) {
      THIS->samplesBuffer[x] = 0;
   }
   for (int x = end;  x < 1000; x++) {
      THIS->samplesBuffer[x] = 0;
   }


   float lfoRate = THIS.global.modeManager.mode2.param1.value;
   float lfoAmount = THIS.global.modeManager.mode2.param2.value / 100;



   for (int x = 0; x < inNumberFrames; x++) {
      
      
      THIS->timeIndex++;
      
      
      if (THIS.bufferIndex >= end) THIS.bufferIndex = start;
      if (THIS->samplesBuffer[THIS.bufferIndex] > 1) THIS->samplesBuffer[THIS.bufferIndex] = 1;
      if (THIS->samplesBuffer[THIS.bufferIndex] < -1) THIS->samplesBuffer[THIS.bufferIndex] = -1;
      
      
      
      if (THIS->timeIndex % (int)lfoRate == 0) lfoAmount = -lfoAmount;
      THIS->samplesBuffer[THIS.bufferIndex] += lfoAmount;
      
      
      
      
      temp[x] = THIS->samplesBuffer[THIS.bufferIndex];
      
      THIS.bufferIndex++;

   }
   
   
  // ioData->mBuffers[0].mData = THIS->samplesBuffer;
   
   return noErr;
}















#pragma mark - custom DSP -


float gainSample(float * data, int amount) {
   
   
   float gainSample = *(data);
   gainSample *= amount;
   
   if (gainSample > 0.8) gainSample = 1;
   if (gainSample < -0.8) gainSample = -1;
   
   return gainSample;
   
}



void gain(float * data, int amount, int n) {
   
   for (int x = 0; x < n; x++) {
      
      
      float gainSample = *(data + x);
      gainSample *= amount;
      
      if (gainSample > 0.8) gainSample = 1;
      if (gainSample < -0.8) gainSample = -0.0;
      
      *(data + x) = gainSample;
   }
   
}





#pragma mark - generate getters -





- (float *)getsamplesBuffer {
   return samplesBuffer;
}



#pragma mark - effect controls -

- (void)setEffect1:(float)amount {
}


- (void)setEffect2:(float)amount {
}

- (void)setEffect3:(float)amount {
}

- (void)setEffect4:(float)amount {
}

- (void)setEffect5:(float)amount {
}









@end
