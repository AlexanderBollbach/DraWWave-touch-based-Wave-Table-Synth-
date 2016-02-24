//
//  Draw_Helper.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/22/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Draw_Helper : NSObject

- (void)pushPoint:(CGPoint)point withDirection:(BOOL)direction;


- (void)reset;

+ (instancetype)sharedInstance;

- (void)dump;


- (NSMutableArray *)getMissingPoints_WithDirection:(BOOL)direction;

@end

