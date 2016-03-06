//
//  Draw_Helper.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/22/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "Draw_Helper.h"
#import "AudioController.h"

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



- (void)pushPoint:(CGPoint)point withDirection:(BOOL)direction {
   
   NSMutableArray * points = [NSMutableArray array];
   
   xAxis[idx] = point.x;
   yAxis[idx] = point.y;
   
   
  points = [self getMissingPoints_WithDirection:direction];

   [points addObject:[NSValue valueWithCGPoint:point]];

   
   for (NSValue * pointValue in points) {
      CGPoint missingPoint = [pointValue CGPointValue];
      [self writeSampleWithPoint:missingPoint];
   }
   
   idx++;

}




- (void)writeSampleWithPoint:(CGPoint)point {

   
   static int a = 0;
   a++;
   
//   NSLog(@"%@ ", NSStringFromCGPoint(point));
   NSLog(@"%i", a);
   
      float w = [UIScreen mainScreen].bounds.size.width;
      float h = [UIScreen mainScreen].bounds.size.height;
   
      float xPos = point.x;
      float amp = alexMap(point.y, 0, h, 1, 0);
   
   
      int i = alexMap(xPos, 0, w, 0, w);
   
      float * buffer = [[AudioController sharedInstance] PgetsamplesBuffer];
   
      buffer[i] = amp;
   
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

- (void)dump {
   
   for (int x = 0 ; x < 100; x++) {
      printf("xAxis[%i] = %i \n",x,xAxis[x]);
   }
   for (int x = 0 ; x < 100; x++) {
      printf("yAxis[%i] = %f \n",x,yAxis[x]);
   }
}


- (NSMutableArray *)getMissingPoints_WithDirection:(BOOL)direction {
   
   NSMutableArray *missingPoints = [NSMutableArray array];
   
   int missing = 0;
   int j = 1;
   
   
   int this = xAxis[idx];
   int last = xAxis[idx - j];
   
   if (this != (last + j) && !(idx == 0) && !(this == last)) {
      missing = abs(this - last);
   } else {
      return nil;
   }
   
   //
   //   if (missing == 0) { // can missing even be 0 at this point?
   //      return nil;
   //   }
   
   float yLo = yAxis[idx - 1];
   float yHi = yAxis[idx];
   float ave = (yHi - yLo) / missing; // because i am not taking abs value of ylo and yhi difference the slope is implicit.  i.e. i don't have to change "y += ave" to "y -= ave" if yHi is lower than yLo. also, it doesn't seem that direction needs to be taken into account for y+=ave...
   
   //   if (!direction) {
   //      ave = -ave;
   //   }
   
   float y = yLo;
   
   for (int x = 0; x < missing; x++) {
      
      int baseX = xAxis[idx - j] + ((direction) ? 1 : -1);
      CGPoint point = CGPointMake(baseX + ((direction) ? x : -x), (y += ave));
      [missingPoints addObject:[NSValue valueWithCGPoint:point]];
      
   }
   return missingPoints;
}


@end
