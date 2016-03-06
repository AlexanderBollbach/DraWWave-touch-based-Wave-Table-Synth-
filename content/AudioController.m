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
   
   
   float * samplesBuffer;
   
   int timeIndex;
   int bufferIndex;
   
   float duration;
   
   
   
   
   float param1;
   float param2;
   float param3;
   float param4;
   float param5;
   float param6;
   float param7;
   float param8;
   
   
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
      
      myStuff.samplesBuffer = malloc(10000000 * sizeof(float));
      
      
      
      self.bufferDuration = kBufferDuration;
      
      
      [self initializeAudioSession];
      [self initializeAU];
      
      
      CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
      [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
      
      
      [self PsetReverbAmount:0];
      
      [self setup];
      
   }
   return self;
}




- (void)setup {
   
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
   [center addObserver:self selector:@selector(parameterChanged:) name:@"parameterChanged" object:nil];
   
   
   
   myStuff.param1 = 1;
   myStuff.param2 = 1;
   myStuff.param3 = 1;
   myStuff.param4 = 1;
   myStuff.param5 = 1;
   myStuff.param6 = 1;
   myStuff.param7 = 1;
   myStuff.param8 = 1;
}


- (void)parameterChanged:(NSNotification *)notification {
   
   KS_Parameter_t param = (KS_Parameter_t)[[notification.userInfo objectForKey:@"Id"] integerValue];
   float value = [[notification.userInfo objectForKey:@"value"] floatValue];
   
   switch (param) {
      case KS_Parameter1:
         [self parameter1ChangedWithValue:value];
         break;
      case KS_Parameter2:
         [self parameter2ChangedWithValue:value];
         break;
      case KS_Parameter3:
         [self parameter3ChangedWithValue:value];
         break;
      case KS_Parameter4:
         [self parameter4ChangedWithValue:value];
         break;
      case KS_Parameter5:
         [self parameter5ChangedWithValue:value];
         break;
      case KS_Parameter6:
         [self parameter6ChangedWithValue:value];
         break;
      case KS_Parameter7:
         [self parameter7ChangedWithValue:value];
         break;
      case KS_Parameter8:
         [self parameter8ChangedWithValue:value];
         break;
      default:
         break;
   }
}


/* parameter table
 
 1. lfo1 rate
 2. lfo1 amount
 3. lfo2 rate
 4. lfo2 amount
 
 5. gap1 period
 6. gap1 width
 
 */

- (void)parameter1ChangedWithValue:(float)value {
   value = alexMap(value, 0, 100, 0, 50);
   myStuff.param1 = value;
   
}

- (void)parameter2ChangedWithValue:(float)value {
   value = alexMap(value, 0, 100, 0, 0.2);
   myStuff.param2 = value;
   
}

- (void)parameter3ChangedWithValue:(float)value {
   value = alexMap(value, 0, 100, 0, 50);
   myStuff.param3 = value;
   
}

- (void)parameter4ChangedWithValue:(float)value {
   value = alexMap(value, 0, 100, 0, 0.2);
   myStuff.param4 = value;
   
}

- (void)parameter5ChangedWithValue:(float)value {
   
   value = alexMap(value, 0, 100, 0, 500);
   myStuff.param5 = value;
}

- (void)parameter6ChangedWithValue:(float)value {
   
   value = alexMap(value, 0, 100, 10, 100);
   myStuff.param6 = value;
   
}

- (void)parameter7ChangedWithValue:(float)value {
   
   myStuff.param7 = value;
   
}

- (void)parameter8ChangedWithValue:(float)value {
   
   myStuff.param8 = value;
   
}


// read out for visuals
- (void)tick {
   float sum = 0;
   // for (int x = 0; x < 250; x++) {
   sum += myStuff.samplesBuffer[5];
   //  }
   
   
   sum = alexMap(sum, -1, 1, 0, 1);
   
   [self.delegate waveFormChangedWithValue:sum];
}





#pragma mark - remoteIO Playback -


OSStatus playbackCallback(void * inRefCon,
                          AudioUnitRenderActionFlags * ioActionFlags,
                          const AudioTimeStamp * inTimeStamp,
                          UInt32 inBusNumber,
                          UInt32 inNumberFrames,
                          AudioBufferList * ioData) {
   
   stuff_t * THIS = (stuff_t *)inRefCon;
   
   
   // temp reference to buffer to fill
   float * bufferToFill = ioData->mBuffers[0].mData;
   
   //   int start = 1;
   int duration = THIS->duration;
   
   float lfo1Rate = THIS->param1;
   float lfo1Amount = THIS->param2;
   
   float lfo2Rate = THIS->param3;
   float lfo2Amount = THIS->param4;
   
   int gap1Period = THIS->param5;
   int gap1Width = THIS->param6;
   
   
   if (lfo2Rate <= 0) {
      lfo2Rate = 1;
   }
   if (lfo1Rate <= 0) {
      lfo1Rate = 1;
   }
   
   
   int gap1Decrement = 0;
   
   // write samples to buffer
   for (int x = 0; x < inNumberFrames; x++) {
      
      
      
      // bufferIndex manages the current index of samplesBuffer to mutate and the current frame to store in BufferToFill (ioData).  bufferIndex wraps around to 0 each 'duration' frames.  However, 'timeIndex' can either wrap around or continue growing.  wrapping around gives a more quantized-waveform while infinite growth creates a more continuous natural evolution of the wave
      
      if (THIS->bufferIndex >= duration) {
         THIS->bufferIndex = 0;
         //         THIS->timeIndex = 0;
      }
      
      
      // lfo1
      if (THIS->timeIndex % (int)lfo1Rate == 0) lfo1Amount = -lfo1Amount;
      THIS->samplesBuffer[THIS->bufferIndex] += lfo1Amount;
      
      // lfo2
      if (THIS->timeIndex % (int)lfo2Rate == 0) lfo2Amount = -lfo2Amount;
      THIS->samplesBuffer[THIS->bufferIndex] += lfo2Amount;
      
      // gap1
      if (THIS->bufferIndex % gap1Period == 0) {
         gap1Decrement = gap1Width;
      }
      gap1Decrement--;
      
      
      
      // limiter
      if (THIS->samplesBuffer[THIS->bufferIndex] > 1) THIS->samplesBuffer[THIS->bufferIndex] = 1;
      if (THIS->samplesBuffer[THIS->bufferIndex] < -1) THIS->samplesBuffer[THIS->bufferIndex] = -1;
      
      
      if (gap1Decrement > 0) {
         THIS->samplesBuffer[THIS->bufferIndex] = -1;
      }
      
      // fill playback buffer
      bufferToFill[x] = THIS->samplesBuffer[THIS->bufferIndex];
      
      
      
      THIS->bufferIndex++;
      THIS->timeIndex++;
   }
   
   
   return noErr;
}






#pragma mark - setters / getters -

- (float *)PgetsamplesBuffer {
   return myStuff.samplesBuffer;
}


- (float)PgetNumOfSamples {
   return myStuff.duration;
}


- (void)PsetDuration:(float)value {
   myStuff.duration = value;
}


- (OSStatus)PsetReverbAmount:(float)amount {
   
   int scope = 0; // input scope
   
   OSStatus err = AudioUnitSetParameter(reverbUnit,
                                        kAudioUnitScope_Global,
                                        scope,
                                        kReverb2Param_DryWetMix,
                                        amount,
                                        0);
   return err;
}





























#pragma mark - Audio Session -

- (void)initializeAudioSession {
   
   NSError *audioSessionError = nil;
   AVAudioSession *session = [AVAudioSession sharedInstance];
   
   // set category
   [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&audioSessionError];
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
   //   NSLog(@"Sample Rate:%0.0fHz I/O Buffer Duration:%f", sampleRate, self.bufferDuration);
   
   NSLog(@"vol %f", session.outputVolume);
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
