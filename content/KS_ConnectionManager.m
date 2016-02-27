//
//  KaossManager.m
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "KS_ConnectionManager.h"

@implementation KS_ConnectionManager


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
   self.connections = [NSMutableArray array];
}


- (void)addConnectionWithKS_Element:(KS_Element_t)element andKS_Parameter:(KS_Parameter_t)parameter {
   
   KS_Connection * connection = [[KS_Connection alloc] init];
   connection.element = element;
   connection.parameter = parameter;
   
   [self.connections addObject:connection];
}

- (void)breakConnectionsWithElement:(KS_Element_t)element {
   
   NSMutableArray * toRemove = [NSMutableArray array];
   for (KS_Connection * connection in self.connections) {
      if (connection.element == element) {
         [toRemove addObject:connection];
      }
   }
   [self.connections removeObjectsInArray:toRemove];
}


@end
