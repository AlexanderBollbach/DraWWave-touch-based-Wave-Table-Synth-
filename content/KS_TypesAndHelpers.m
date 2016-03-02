//
//  KS_TypesAndHelpers.m
//  DraWave
//
//  Created by alexanderbollbach on 2/27/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_TypesAndHelpers.h"

@implementation KS_TypesAndHelpers


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
   
   
   
   
   
}
- (NSString *)getNameFromKS_Element:(KS_Element_t)element {
   switch (element) {
      
      case KS_Element1:
         return @"KS_X1";
         break;
      case KS_Element2:
         return @"KS_Y1";
         break;
      case KS_Element3:
         return @"KS_X2";
         break;
      case KS_Element4:
         return @"KS_Y2";
         break;
         
      default:
         break;
   }
 
}


- (NSString *)getNameFromKS_Parameter:(KS_Parameter_t)parameter {
   
   switch (parameter) {
      case KS_Parameter1:
         return @"samples long";
         break;
      case KS_Parameter2:
         return @"samples short";
         break;
      case KS_Parameter3:
         return @"lfo rate";
         break;
      case KS_Parameter4:
         return @"lfo amount";
         break;
      case KS_Parameter5:
         return @"reverb amount";
         break;
      case KS_Parameter6:
         return @"blank2";
         break;
         
      default:
         break;
   }
   
}



@end
