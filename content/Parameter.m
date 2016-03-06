//
//  Parameter.m
//  DraWave
//
//  Created by alexanderbollbach on 3/5/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Parameter.h"



@implementation Parameter

+ (Parameter *)parameterWithName:(NSString *)name Id:(KS_Parameter_t)Id andValue:(float)value {
   
   Parameter * param = [[self alloc] init];
   param.name = name;
   param.parameterId = Id;
   param.value = value;
   
   return param;
   
}

@end
