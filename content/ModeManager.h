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

@protocol ModeManagerDelegate <NSObject>

- (void)parameterChangedWithName:(NSString *)name andValue:(float)value;

@end

@interface ModeManager : NSObject <ModeDelegate>

@property (nonatomic,strong) SampleMode * mode1;
@property (nonatomic,strong) CreateMode * mode2;
@property (nonatomic,strong) Mode * mode3;
@property (nonatomic,strong) Mode * mode4;
@property (nonatomic,strong) Mode * mode5;

@property (nonatomic,strong) Mode * activeMode;

@property (nonatomic,strong) NSMutableArray * allModes;

@property (nonatomic,strong) id <ModeManagerDelegate> delegate;


- (void)setActiveModeWithId:(int)Id;



// supplies [controls view] with mode information
- (NSString *)getNameForMode:(int)mode;
- (NSString *)getNameForParam:(int)paramId ofMode:(int)modeId;
- (NSString *)getNameForActiveParam:(int)paramId;

- (BOOL)isModeActive:(int)mode;


@end
