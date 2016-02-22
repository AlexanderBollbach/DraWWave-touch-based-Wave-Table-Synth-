//
//  Draw_Helper.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/22/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Draw_Helper.h"
#import <UIKit/UIKit.h>

@implementation Draw_Helper {
   
   int xAxis[1000];
   float yAxis[1000];
   
   int idx;

   
}


// object is defined as singleton but is not "thread safe"  in that many objects can theoretically gain reference to this singleton and "use" it for "help". however, as of "V1.0.0" only viewController uses this object. If in the future more than one classes does it should be made able to be "locked" or much more likely, make instance per reference.  hence, no singleton.


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
      [self reset];
   }
   return self;
}



- (void)pushXValue:(int)value {
   xAxis[idx] = value;
 
}

- (void)pushYValue:(int)value {
   yAxis[idx] = value;
  
}


- (void)increment {
   idx++;
}


- (void)reset {
   idx = 0;
   
   for (int x = 0 ; x < 1000; x++) {
      xAxis[x] = 0;
   }
   for (int x = 0 ; x < 1000; x++) {
      yAxis[x] = 0;
   }
   
}







- (NSMutableArray *)getMissingPoints_WithDirection:(BOOL)direction {
   
   NSMutableArray *missingPoints = [NSMutableArray array];
   
   int missing = 0;
   int j = 1;

      int this = xAxis[idx];
      int last = xAxis[idx - j];
      if (this != (last + 1) && !(idx - j < 0) && !(this == last)) {
         missing = this - last;
      } else {
         return nil;
      }
      
   
//   if (idx - j < 0) {
//      return nil;
//   }
   
//   if (this == last) {
//      return nil;
//   }
//   
   
    //  j++;
      
   //}
   
   if (missing == 0) { // can missing even be 0 at this point?
      return nil;
   }
   
   
   // now create samples
   
   float yLo = yAxis[idx -  1];
   float yHi = yAxis[idx];
   float ave = (yHi - yLo) / missing;
   
   float y = yLo;

   for (int x = 0; x < missing; x++) {

      int baseX = xAxis[idx - 1] + 1;
      CGPoint point = CGPointMake(baseX + x, (y += ave));
      [missingPoints addObject:[NSValue valueWithCGPoint:point]];
      
   }
   return missingPoints;
}


- (void)dump {
   
   for (int x = 0 ; x < 100; x++) {
      printf("xAxis[%i] = %i \n",x,xAxis[x]);
   }
   for (int x = 0 ; x < 100; x++) {
      printf("yAxis[%i] = %f \n",x,yAxis[x]);
   }
}



// NEW BELOW WITH REVERSE


//
//
//
//- (NSMutableArray *)getMissingPoints_WithDirection:(BOOL)direction {
//   
//   NSMutableArray *missingPoints = [NSMutableArray array];
//   
//   int missing = 0;
//   int j;
//   
//   if (direction == YES) {
//      j = 1;
//   }  else {
//      j = -1;
//   }
//   
//   int this = xAxis[idx];
//   int last = xAxis[idx - j];
//   
//   if (this != (last + j) && !(idx - j < 0) && !(this == last)) {
//      missing = this - last;
//   } else {
//      return nil;
//   }
//   
//   //
//   //   if (missing == 0) { // can missing even be 0 at this point?
//   //      return nil;
//   //   }
//   
//   float yLo = yAxis[idx - j];
//   float yHi = yAxis[idx];
//   float ave = (yHi - yLo) / missing;
//   
//   if (direction) {
//      ave = -ave;
//   }
//   
//   float y = yLo;
//   
//   for (int x = 0; x < missing; x++) {
//      
//      int baseX = xAxis[idx - j] + 1;
//      CGPoint point = CGPointMake(baseX + x, (y += ave));
//      [missingPoints addObject:[NSValue valueWithCGPoint:point]];
//      
//   }
//   return missingPoints;
//}


@end
