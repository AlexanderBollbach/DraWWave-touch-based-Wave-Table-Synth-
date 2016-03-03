//
//  KS_TypesAndHelpers.h
//  DraWave
//
//  Created by alexanderbollbach on 2/27/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
   
   KS_Element1,
   KS_Element2,
   KS_Element3,
   KS_Element4
   
} KS_Element_t;


typedef enum {
   
   KS_Parameter1,
   KS_Parameter2,
   KS_Parameter3,
   KS_Parameter4,
   KS_Parameter5,
   KS_Parameter6,
   KS_Parameter7,
   KS_Parameter8
   
} KS_Parameter_t;


typedef enum {
   
   settings1,
   settings2,
   settings3,
   settings4
   
} settingsType_t;

typedef enum {
   
   torus,
   parameters,
   empty,
   empty2
   
} menuSelect_t;


@interface KS_TypesAndHelpers : NSObject


- (NSString *)getNameFromKS_Parameter:(KS_Parameter_t)parameter;
- (NSString *)getNameFromKS_Element:(KS_Element_t)element;

+ (instancetype)sharedInstance;


@end
