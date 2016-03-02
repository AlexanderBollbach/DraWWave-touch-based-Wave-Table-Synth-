//
//  CV_lineDrawer.h
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KS_LineDrawer : UIView

@property (nonatomic) CGPoint chosenGesturePoint;
@property (nonatomic) CGPoint currentPoint;
@property BOOL drawChoosingLine;

@property BOOL KS_Element1_isConnected;
@property CGPoint KS_Element1_From;
@property CGPoint KS_Element1_To;

@property BOOL KS_Element2_isConnected;
@property CGPoint KS_Element2_From;
@property CGPoint KS_Element2_To;

@property BOOL KS_Element3_isConnected;
@property CGPoint KS_Element3_From;
@property CGPoint KS_Element3_To;

@property BOOL KS_Element4_isConnected;
@property CGPoint KS_Element4_From;
@property CGPoint KS_Element4_To;

@end
