//
//  Parameter.h
//  DraWave
//
//  Created by alexanderbollbach on 3/5/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KS_TypesAndHelpers.h"

@interface Parameter : NSObject

@property (nonatomic,strong) NSString * name;
@property KS_Parameter_t parameterId;
@property float value;

+ (Parameter *)parameterWithName:(NSString *)name Id:(KS_Parameter_t)Id andValue:(float)value;

@end
