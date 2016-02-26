//
//  Mode.h
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mode.h"

#import "SampleMode.h"
#import "CreateMode.h"
#import "LFOMode.h"

@protocol ModeManagerDelegate <NSObject>

- (void)parameterChangedWithName:(NSString *)name andValue:(float)value;

@end

@interface ModeManager : NSObject <ModeDelegate>

@property (nonatomic,strong) SampleMode * mode1;
@property (nonatomic,strong) LFOMode * mode2;
@property (nonatomic,strong) Mode * mode3;
@property (nonatomic,strong) Mode * mode4;
@property (nonatomic,strong) Mode * mode5;

@property (nonatomic,strong) Mode * activeMode;

@property (nonatomic,strong) NSMutableArray * allModes;

@property (nonatomic,strong) id <ModeManagerDelegate> delegate;



@property (nonatomic,strong) Parameter * waveStart;
@property (nonatomic,strong) Parameter * waveEnd;
@property (nonatomic,strong) Parameter * lfoAmount;
@property (nonatomic,strong) Parameter * lfoRate;

@property (nonatomic,strong) Parameter * activeXParam;
@property (nonatomic,strong) Parameter * activeYParam;


- (void)setActiveModeWithId:(int)Id;



// supplies [controls view] with mode information
- (NSString *)getNameForMode:(int)mode;
- (NSString *)getNameForParam:(int)paramId ofMode:(int)modeId;
- (NSString *)getNameForActiveParam:(int)paramId;

- (BOOL)isModeActive:(int)mode;



- (void)setActiveXParamValue:(float)value;
- (void)setActiveYParamValue:(float)value;


@end
