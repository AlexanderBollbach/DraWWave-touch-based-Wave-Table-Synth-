//
//  MainParameters.m
//  DraWave
//
//  Created by alexanderbollbach on 3/5/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "MainParameters.h"

NSString * const XXFooDidBarNotification = @"ABParamChange";


@interface MainParameters()

@property (nonatomic,strong) Parameter * param1;
@property (nonatomic,strong) Parameter * param2;
@property (nonatomic,strong) Parameter * param3;
@property (nonatomic,strong) Parameter * param4;
@property (nonatomic,strong) Parameter * param5;
@property (nonatomic,strong) Parameter * param6;
@property (nonatomic,strong) Parameter * param7;
@property (nonatomic,strong) Parameter * param8;

@property (nonatomic,strong) NSMutableArray * allParams;
@end

@implementation MainParameters

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
      [self setup];
   }
   return self;
}

- (void)setup {
   
   
   self.param1 = [Parameter parameterWithName:@"lfo1Rate" Id:KS_Parameter1 andValue:0];
   self.param2 = [Parameter parameterWithName:@"lfo1Amount" Id:KS_Parameter2 andValue:0];
   self.param3 = [Parameter parameterWithName:@"lfo2Rate" Id:KS_Parameter3 andValue:0];
   self.param4 = [Parameter parameterWithName:@"lfo2Amount" Id:KS_Parameter4 andValue:0];
   self.param5 = [Parameter parameterWithName:@"empty" Id:KS_Parameter5 andValue:0];
   self.param6 = [Parameter parameterWithName:@"empty" Id:KS_Parameter6 andValue:0];
   self.param7 = [Parameter parameterWithName:@"empty" Id:KS_Parameter7 andValue:0];
   self.param8 = [Parameter parameterWithName:@"empty" Id:KS_Parameter8 andValue:0];
   
   
   self.allParams = [NSMutableArray arrayWithObjects:
                     self.param1,
                     self.param2,
                     self.param3,
                     self.param4,
                     self.param5,
                     self.param6,
                     self.param7,
                     self.param8, nil];
}


- (void)setValue:(float)value withParameterId:(KS_Parameter_t)parameter {
   
   Parameter * param = [self.allParams objectAtIndex:parameter];
   
   param.value = value;
   
   NSDictionary * userInfoDict = @{
                                   @"name" : param.name,
                                   @"Id" : [NSNumber numberWithInt:param.parameterId],
                                   @"value" :[NSNumber numberWithFloat:param.value]
                                   
                                   };
   
   [[NSNotificationCenter defaultCenter] postNotificationName:@"parameterChanged" object:nil userInfo:userInfoDict];

   
}

@end
