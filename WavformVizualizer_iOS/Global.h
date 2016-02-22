//
//  GOD.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol globalDelegator <NSObject>
- (void)samplesOnScreenChanged;

@end

typedef enum {
   mode1 = 1,
   mode2,
   mode3,
   mode4,
   mode5
} Mode_State;

typedef struct Mode_Settings {
   
   Mode_State modeState;
   
   float mode1_PanState_X;
   float mode2_PanState_X;
   float mode3_PanState_X;
   float mode4_PanState_X;
   float mode5_PanState_X;
   
} Mode_Settings;

@interface Global : NSObject {
@public

   Mode_Settings mode_settings;
}


@property (atomic,assign) int startingSample;
@property (atomic,assign) int samplesOnScreen;


@property (nonatomic,strong) id<globalDelegator> delegate;

+ (instancetype)sharedInstance;
- (void)writeSampleWithPoint:(CGPoint)point;

@end
