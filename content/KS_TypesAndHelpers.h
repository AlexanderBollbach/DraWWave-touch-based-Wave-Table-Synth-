//
//  KS_TypesAndHelpers.h
//  DraWave
//
//  Created by alexanderbollbach on 2/27/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
   
   KS_X1,
   KS_Y1,
   KS_X2,
   KS_Y2
   
} KS_Element_t;


typedef enum {
   
   KS_samplesDurationLong,
   KS_samplesDuration,
   KS_lfoRate,
   KS_lfoAmount,
   KS_reverbAmount,
   KS_blank2
   
} KS_Parameter_t;


@interface KS_TypesAndHelpers : NSObject


- (NSString *)getNameFromKS_Parameter:(KS_Parameter_t)parameter;

+ (instancetype)sharedInstance;


@end
