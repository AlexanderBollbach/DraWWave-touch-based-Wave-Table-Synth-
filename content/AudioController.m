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

#define kOutputBus 0
#define kInputBus 1
#define kSampleRate 88200
#define kBufferDuration 0.01


typedef struct stuff {
   
   //   float waveStart;
   
   
   float * samplesBuffer;
   
   int index;
   int timeIndex;
   int bufferIndex;
   
   
   
   float samplesDuration;
   
   float lfoRate;
   float lfoAmount;
   
} stuff_t;


@interface AudioController() {
   AudioUnit remoteIOUnit;
   AudioUnit reverbUnit;
   
}

@property (nonatomic,assign) float bufferDuration;


@end

@implementation AudioController {
   stuff_t myStuff;
}



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
      
      myStuff.samplesBuffer = malloc(1000000 * sizeof(float));
      
      self.bufferDuration = kBufferDuration;
      
      
      [self initializeAudioSession];
      [self initializeAU];
      
   }
   return self;
}














#pragma mark - remoteIO Playback -


OSStatus playbackCallback(void * inRefCon,
                          AudioUnitRenderActionFlags * ioActionFlags,
                          const AudioTimeStamp * inTimeStamp,
                          UInt32 inBusNumber,
                          UInt32 inNumberFrames,
                          AudioBufferList * ioData) {
   
   stuff_t * THIS = (stuff_t *)inRefCon;
   
   
   // test
   static int a = 0;
   a++;
   //  printf("playback %i \n", a);
   
   
   
   
   
   // temp reference to buffer to fill
   float * bufferToFill = ioData->mBuffers[0].mData;
   
   int start = 1;//THIS->waveStart;
   int duration = THIS->samplesDuration;
   float lfoRate = THIS->lfoRate;
   float lfoAmount = THIS->lfoAmount;
   
   
   
   if (duration <= 0 || start <= 0) {
      return noErr;
   }
   

   
   
   // write samples to buffer
   for (int x = 0; x < inNumberFrames; x++) {
      
      if (THIS->bufferIndex >= duration) {
       //  lfoAmount = fabsf(lfoAmount);
         THIS->bufferIndex = start;
      }
      
      THIS->samplesBuffer[THIS->bufferIndex] += lfoAmount;
      
      if (THIS->timeIndex % (int)lfoRate == 0) lfoAmount = -lfoAmount;
      
      if (THIS->samplesBuffer[THIS->bufferIndex] > 1) THIS->samplesBuffer[THIS->bufferIndex] = 1;
      if (THIS->samplesBuffer[THIS->bufferIndex] < -1) THIS->samplesBuffer[THIS->bufferIndex] = -1;
      
      
      // float val = gainSample(&THIS->samplesBuffer[THIS->bufferIndex], 10);
      
      bufferToFill[x] = THIS->samplesBuffer[THIS->bufferIndex];
      
      
      THIS->bufferIndex++;
      THIS->timeIndex++;
   }
   
   
   return noErr;
}









#pragma mark - setters / getters -

- (float *)getsamplesBuffer {
   return myStuff.samplesBuffer;
}
//- (void)setWaveStartValue:(float)value {
//   myStuff.waveStart = value;
//}
- (void)setSamplesDurationValue:(float)value {
   myStuff.samplesDuration = value;
}

- (void)setLfoRateValue:(float)value {
   myStuff.lfoRate = value;
}
- (void)setLfoAmountValue:(float)value {
   myStuff.lfoAmount = value;
}


- (OSStatus)setReverbAmount:(float)amount {
   
   int scope = 0; // input scope
   
   OSStatus err = AudioUnitSetParameter(reverbUnit,
                                        kAudioUnitScope_Global,
                                        scope,
                                        kReverb2Param_DryWetMix,
                                        amount,
                                        0);
   return err;
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
   //   iocd.componentFlags = 0;
   //   iocd.componentFlagsMask = 0;
   AudioComponent ioComp = AudioComponentFindNext(NULL, &iocd);
   CheckError(AudioComponentInstanceNew(ioComp, &remoteIOUnit), "Couldn't get RIO unit instance");
   
   
   AudioComponentDescription rvcd;
   rvcd.componentType = kAudioUnitType_Effect;
   rvcd.componentSubType = kAudioUnitSubType_Reverb2;
   rvcd.componentManufacturer = kAudioUnitManufacturer_Apple;
   
   AudioComponent rvComp = AudioComponentFindNext(NULL, &rvcd);
   CheckError(AudioComponentInstanceNew(rvComp, &reverbUnit), "Couldn't get RIO unit instance");
   
   
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
   renderCallback.inputProcRefCon = &myStuff;
   CheckError(AudioUnitSetProperty(reverbUnit,
                                   kAudioUnitProperty_SetRenderCallback,
                                   kAudioUnitScope_Output,
                                   kOutputBus,
                                   &renderCallback,
                                   sizeof(renderCallback)), "Couldn't set input callback");
   
   
   
   
   //////// INITIALIZE
   CheckError(AudioUnitInitialize(remoteIOUnit), "Couldn't initialize input unit");
   CheckError(AudioUnitInitialize(reverbUnit), "Couldn't initialize input unit");
   
   
   //connection
   AudioUnitElement reverbOutputBus  = 0;
   AudioUnitElement ioUnitOutputElement = 0;
   
   AudioUnitConnection revOutToRemoteIOIn;
   revOutToRemoteIOIn.sourceAudioUnit    = reverbUnit;
   revOutToRemoteIOIn.sourceOutputNumber = reverbOutputBus;
   revOutToRemoteIOIn.destInputNumber    = ioUnitOutputElement;
   
   OSStatus err = AudioUnitSetProperty (
                                        remoteIOUnit,                     // connection destination
                                        kAudioUnitProperty_MakeConnection,  // property key
                                        kAudioUnitScope_Input,              // destination scope
                                        ioUnitOutputElement,                // destination element
                                        &revOutToRemoteIOIn,                // connection definition
                                        sizeof (revOutToRemoteIOIn)
                                        );
   
   
   
   
   
   err = AudioOutputUnitStart(remoteIOUnit);
   
   //   AudioOutputUnitStop(remoteIOUnit);
}








@end
