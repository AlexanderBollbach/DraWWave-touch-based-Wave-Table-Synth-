//
//  Mode.m
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ParameterManager.h"


@implementation ParameterManager


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
      
      self.gesture_PanX = [[Gesture alloc] init];
      self.gesture_PanX.gesture = panX;
      
      self.gesture_PanY = [[Gesture alloc] init];
      self.gesture_PanY.gesture = panY;
   }
   return self;
}

- (void)unattach:(Gesture_t)gesture {
   
   switch (gesture) {
      case panX:
         self.gesture_PanX.isAttached = NO;
         break;
         
      case panY:
         self.gesture_PanY.isAttached = NO;;
         break;
         
      default:
         break;
   }
}


- (void)connectGesture:(Gesture_t)gesture toParameter:(ParamSelected_t)parameter {
   
   switch (gesture) {
      case panX: {
         self.gesture_PanX.isAttached = YES;
         self.gesture_PanX.controlledParameter = parameter;
         break;
      }
      case panY: {
         self.gesture_PanY.isAttached = YES;
         self.gesture_PanY.controlledParameter = parameter;
         break;
      }
      default:
         break;
   }
}

- (void)setPanXParamValue:(float)value {
   if (!self.gesture_PanX.isAttached) return;
   
   [self.delegate gestureChanged:self.gesture_PanX withValue:value];
}

- (void)setPanYParamValue:(float)value {
   if (!self.gesture_PanY.isAttached) return;
   
   [self.delegate gestureChanged:self.gesture_PanY withValue:value];
}


@end
