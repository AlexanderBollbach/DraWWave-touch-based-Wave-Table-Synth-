//
//  MainParameters.h
//  DraWave
//
//  Created by alexanderbollbach on 3/5/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parameter.h"


extern NSString * const ABParameterDidChangeKey;


@interface MainParameters : NSObject

+ (instancetype)sharedInstance;

- (void)setValue:(float)value withParameterId:(KS_Parameter_t)parameter;

@end
