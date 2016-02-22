//
//  Draw_Helper.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/22/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Draw_Helper : NSObject

- (void)pushXValue:(int)value;

- (void)pushYValue:(int)value;

- (void)reset;

+ (instancetype)sharedInstance;

- (void)dump;

- (void)increment;

//- (int)getMissing;

- (NSMutableArray *)getMissingPoints_WithDirection:(BOOL)direction;


@end

