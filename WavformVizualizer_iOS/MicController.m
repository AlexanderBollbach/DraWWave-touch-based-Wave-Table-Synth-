//
//  MicController.m
//  WaveForm2
//
//  Created by alexanderbollbach on 2/11/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "MicController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "functions.h"
#import <Accelerate/Accelerate.h>
#import "AlexRingBuffer.h"

#define kOutputBus 0
#define kInputBus 1
#define kSampleRate 44100.0
#define kBufferDuration 0.01

typedef struct GenStuff {
   
   float waveLengthPortion;
   int wavelength;
   float theta;
   int idx;
   int onSize;
   int param1;
   int effect1;
   float effect2;
   int effect3;
   int samples;
   
   float * samplesBuffer;
   int samplesBufferIdx;
} GenStuff;

@interface MicController() {
   
   COMPLEX_SPLIT A;
   float * fft_buffer;
   int index;
   
   FFTSetup fftSetup;
   
   
   uint32_t log2n;
   uint32_t n;
   uint32_t nOver2;
   
   AudioUnit remoteIOUnit;
   
   int bufferCapacity;
   
   
   AlexRingBuffer * alexRingBuffer;
   
   GenStuff genStuff;
   
   
   float mangle_waveLengthPortion;
}

@property (nonatomic,assign) float bufferDuration;

@end

@implementation MicController

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
      
      self->alexRingBuffer = [AlexRingBuffer sharedInstance];
      
      self.bufferDuration = kBufferDuration;
      
      
      [self initializeAudioSession];
      [self initializeAU];
      
      
      
      self->genStuff.waveLengthPortion = 25;
      self->genStuff.wavelength = 0;
      self->genStuff.theta = 0.005;
      self->genStuff.idx = 0;
      self->genStuff.onSize = 0;
      self->genStuff.param1 = 0;
      
      self->genStuff.effect1 = 0;
      self->genStuff.effect2 = 0;
      self->genStuff.effect3 = 0;

      self->genStuff.samples = 10;
      
      genStuff.samplesBuffer = malloc(500000 * sizeof(float));

      //   [self setupFFT];
      
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
   
   // register for callbacks when route changes
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
}

- (void)setBufferSizeFromMode:(int)mode {
   
   NSTimeInterval bufferDuration;
   
   switch (mode) {
      case 1:
         bufferDuration = 0.0001;
         break;
      case 2:
         bufferDuration = 0.001;
         break;
      case 3:
         bufferDuration = 0.0; // reserved
         break;
      case 4:
         bufferDuration = 0.0; // reserved
         break;
      case 5:
         bufferDuration = 0.001;
         break;
      default:
         break;
   }
   
   
   //   NSError *audioSessionError = nil;
   //   AVAudioSession *session = [AVAudioSession sharedInstance];
   //
   //
   //   if (self.remoteIOUnit != NULL) {
   //      AudioOutputUnitStop(self.remoteIOUnit);
   //      AudioUnitUninitialize(self.remoteIOUnit);
   //      self.remoteIOUnit = NULL;
   //   }
   
   
   //   [session setActive:NO error:&audioSessionError];
   //
   //   [session setPreferredIOBufferDuration:bufferDuration error:&audioSessionError];
   //   if (audioSessionError) {
   //      NSLog(@"Error %ld, %@",
   //            (long)audioSessionError.code, audioSessionError.localizedDescription);
   //   }
   
   
   
   
}






- (void)initializeAU {
   
   printf("beginningg of intiailize au \n");
   
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
   
   
   
   
   UInt32 shouldAllocateBuffer = 0;
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioUnitProperty_ShouldAllocateBuffer,
                                   kAudioUnitScope_Input,
                                   0,
                                   &shouldAllocateBuffer,
                                   sizeof(shouldAllocateBuffer)), "should alloc");
   
   
   
   
   
   //////// INITIALIZE RemoteIO
   CheckError(AudioUnitInitialize(remoteIOUnit), "Couldn't initialize input unit");
   
   /////////////////////////////////////////////////// bufferlist
   UInt32 maxFrames = 0;
   UInt32 sizeOfMaxFrames = sizeof(maxFrames);
   CheckError( AudioUnitGetProperty(remoteIOUnit,
                                    kAudioUnitProperty_MaximumFramesPerSlice,
                                    kAudioUnitScope_Global,
                                    kOutputBus,
                                    &maxFrames,
                                    &sizeOfMaxFrames), "couldn't get maxFrame");
   
   bufferCapacity = maxFrames;
   
   int offset = offsetof(AudioBufferList, mBuffers[0]);
   int bufferListSizeBytes = offset + (sizeof(AudioBuffer) * myASBD.mChannelsPerFrame);
   
   self.inputBuffer = malloc(bufferListSizeBytes);
   self.inputBuffer->mNumberBuffers = myASBD.mChannelsPerFrame;
   
   UInt32 bufferSizeBytes = maxFrames * sizeof(float);
   
   self.inputBuffer->mBuffers[0].mNumberChannels = 1;
   self.inputBuffer->mBuffers[0].mDataByteSize = bufferSizeBytes;
   self.inputBuffer->mBuffers[0].mData = malloc(bufferSizeBytes);
   
   
   
   
   
   
   /////////////////////////////////////////////// callback setup
   AURenderCallbackStruct callbackStruct;
   callbackStruct.inputProc = inputCallback;
   callbackStruct.inputProcRefCon = (__bridge void * _Nullable)self;
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioOutputUnitProperty_SetInputCallback,
                                   kAudioUnitScope_Global,
                                   kInputBus,
                                   &callbackStruct,
                                   sizeof(callbackStruct)), "Couldn't set input callback");
   AURenderCallbackStruct renderCallback;
   renderCallback.inputProc = playbackCallback;
   renderCallback.inputProcRefCon = (__bridge void * _Nullable)self;
   CheckError(AudioUnitSetProperty(remoteIOUnit,
                                   kAudioUnitProperty_SetRenderCallback,
                                   kAudioUnitScope_Output,
                                   kOutputBus,
                                   &renderCallback,
                                   sizeof(renderCallback)), "Couldn't set input callback");
   
   
   
   
   
   
   ////////////  START ///
   CheckError(AudioOutputUnitStart(remoteIOUnit), "Couldn't initialize input unit");
   
 //  printf("max frame = %i \n", maxFrames);
   
}












#pragma mark - remoteIO Playback -


OSStatus playbackCallback(void * inRefCon,
                          AudioUnitRenderActionFlags * ioActionFlags,
                          const AudioTimeStamp * inTimeStamp,
                          UInt32 inBusNumber,
                          UInt32 inNumberFrames,
                          AudioBufferList * ioData) {
   
   MicController *SELFP = (__bridge MicController *)inRefCon;
   
   
   
   // incoming samples
   float * sample = SELFP.inputBuffer->mBuffers[0].mData;
   
   
//   if (SELFP->genStuff.idx >= 1000) {
//      [SELFP->alexRingBuffer flush];
//   }
   
   
   // generate synth data

//      generate(sample,
//            inNumberFrames,
//            &SELFP->genStuff);
//   
//   
   
   
   sample = SELFP->genStuff.samplesBuffer; // my buffer to playback buffer


   
   // set buffer ot play out
   ioData->mBuffers[0].mData = sample;
   
   
   
   
   
   
   
   // place in ringBuff for display
   //   for (int x = 0; x < inNumberFrames; x++) {
   //      [SELFP->alexRingBuffer putFloat:sample[x]];
   //   }
   
   return noErr;
}















#pragma mark - custom DSP -


void generate(float * data,
              int n,
              GenStuff * stuff) {
   
   static bool on1 = false;
   static bool on2 = false;

   static float LFO = 0;
   static bool dir = false;
   
   int * idx = &stuff->idx;

   
   static int counter = 0;
   
   for (int x = 0; x < n; x++) {
      
      counter++;
 
      
      if (counter % 9000 == 0) {
         dir = !dir;
      }
      
      if (dir) {
         LFO = stuff->effect2;
      } else {
         LFO = -stuff->effect2;
      }
      
      if (*idx >= stuff->samples) { // samples everything
         *idx = 0;
         on1 = false;
         on2 = false;
       //  dir = false;
      }

 //     float * sample = &stuff->samplesBuffer[*idx];
    //  printf("b4 sample %f \n", *sample);
        // *sample += LFO;
    //  printf("af sample %f \n", *sample);


    //  stuff->samplesBuffer[*idx] = data[x];

      
      

      
      
     (*idx)++;
   }

   
}



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

- (int *)getsamplesSize {
   return &genStuff.samples;
}

- (int*)getsamplesIndex {
   return &genStuff.idx;
}


- (float *)getsamplesBuffer {
   return genStuff.samplesBuffer;
}



#pragma mark - effect controls -

- (void)setEffect1:(float)amount {
   self->genStuff.samples = amount;
}


- (void)setEffect2:(float)amount {
   self->genStuff.effect2 = amount;
}

- (void)setEffect3:(float)amount {
   self->genStuff.effect2 = amount;
}

- (void)setEffect4:(float)amount {
   self->genStuff.effect2 = amount;
}

- (void)setEffect5:(float)amount {
   self->genStuff.samples = amount;
}





#pragma mark - remoteIO input -


OSStatus inputCallback(void *inRefCon,
                       AudioUnitRenderActionFlags *ioActionFlags,
                       const AudioTimeStamp *inTimeStamp,
                       UInt32 inBusNumber,
                       UInt32 inNumberFrames,
                       AudioBufferList * ioData) {
   
   MicController *SELFP = (__bridge MicController *)inRefCon;
   
   CheckError(AudioUnitRender(SELFP->remoteIOUnit,
                              ioActionFlags,
                              inTimeStamp,
                              inBusNumber,
                              inNumberFrames,
                              SELFP.inputBuffer), "audio unit render");
   
   
   
   {
      //   COMPLEX_SPLIT A = SELFP->A;
      //   FFTSetup fftSetup = SELFP->fftSetup;
      //   uint32_t log2n = SELFP->log2n;
      //   uint32_t n = SELFP->n;
      //   uint32_t nOver2 = SELFP->nOver2;
      //   float * fft_Buffer = SELFP->fft_buffer;
      
      
      
      
      //   ///////////////////// Read (maxFrames) into fft buffer.///////
      //   int read = SELFP->bufferCapacity - SELFP->index;
      //   if (read > inNumberFrames) {
      //      memcpy(
      //             fft_Buffer + SELFP->index,
      //             SELFP.inputBuffer->mBuffers[0].mData,
      //             inNumberFrames*sizeof(float)
      //             );
      //      SELFP->index += inNumberFrames;
      //   } else {
      //      memcpy(
      //             fft_Buffer + SELFP->index,
      //             SELFP.inputBuffer->mBuffers[0].mData,
      //             read*sizeof(float)
      //             );
      //      SELFP->index = 0;
      //
      ////      for (int x = 0;x < SELFP->bufferCapacity + 1000; x++) {
      ////         printf("val:%i is: %f \n", x,*(fft_Buffer + x));
      ////      }
      ////
      //
      //      /////////////////////////////////////// FFT
      //      vDSP_ctoz((COMPLEX*)fft_Buffer, 2, &A, 1, nOver2);
      //      vDSP_fft_zrip(fftSetup, &A, 1, log2n, FFT_FORWARD);
      //      vDSP_ztoc(&A, 1, (COMPLEX *)fft_Buffer, 2, nOver2);
      //
      //
      //      /////////// REFORMAT
      //      float dominantFrequency = 0;
      //      int bin = -1;
      //      for (int i = 0; i < n; i += 2) {
      //
      //         float x = fft_Buffer[i];
      //         float y = fft_Buffer[i+1];
      //         float curFreq = ((x*x) + (y*y));
      //
      //         if (curFreq > dominantFrequency) {
      //            dominantFrequency = curFreq;
      //            bin = (i+1)/2;
      //         }
      //      }
      //      printf("Dominant frequency: %d \n", bin*(44100/SELFP->bufferCapacity));
      //
      //
      //   }
      
   }
   
   
   return noErr;
}

#pragma mark - setup FFT -

- (void)setupFFT {
   
   UInt32 maxFrames = self->bufferCapacity;
   int toMalloc = maxFrames * sizeof(float) + 10 ;
   self->fft_buffer = (void*)malloc(toMalloc);
   memset(self->fft_buffer, 0, toMalloc);
   log2n = log2f(maxFrames);
   n = 1 << log2n;
   assert(n == maxFrames);
   nOver2 = maxFrames/2;
   bufferCapacity = maxFrames;
   index = 0;
   A.realp = (float *)malloc(nOver2 * sizeof(float));
   A.imagp = (float *)malloc(nOver2 * sizeof(float));
   fftSetup = vDSP_create_fftsetup(log2n, FFT_RADIX2);
   
   
   
}


#pragma mark - remoteIO Helpers -

- (void)remoteIOSetRunning:(BOOL)running {
   
   if (running == YES) {
      CheckError(AudioOutputUnitStart(remoteIOUnit), "remoteUISetRunning:YES");
   } else {
      CheckError(AudioOutputUnitStop(remoteIOUnit), "remoteUISetRunning:YES");
   }
   
   printf("did this");
}

- (BOOL)remoteIOGetRunning {
   
   UInt32 isRunning = 0;
   UInt32 sizeOfRunning = sizeof(isRunning);
   
   CheckError(AudioUnitGetProperty(remoteIOUnit,
                                   kAudioOutputUnitProperty_IsRunning,
                                   kAudioUnitScope_Global,
                                   0,
                                   &isRunning,
                                   &sizeOfRunning), "couldn't get is running");
   
   if (isRunning == 0) {
      return NO;
   } else {
      return YES;
   }
   
   
}

@end
