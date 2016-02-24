//
//  Mode.h
//  DraWave
//
//  Created by alexanderbollbach on 2/23/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Parameter.h"



@protocol ModeDelegate <NSObject>
- (void)parameterChanged:(NSString *)parameter withValue:(float)value;
@end

@interface Mode : NSObject

@property (nonatomic,strong) NSString * name;

@property (nonatomic,strong) Parameter * param1;
@property (nonatomic,strong) Parameter * param2;
@property (nonatomic,strong) Parameter * param3;


@property (nonatomic,strong) Parameter * activeParameter;
@property (nonatomic,strong) NSMutableArray * allParameters;

@property (nonatomic,weak) id <ModeDelegate> delegate;

- (void)setActiveParamValue:(UIPanGestureRecognizer *)pan andView:(UIView *)view;
- (void)setActiveParameterWithId:(int)Id;


- (Parameter *)getParameter:(int)paramId;

- (BOOL)isParamActive:(int)paramIndex;

@end
