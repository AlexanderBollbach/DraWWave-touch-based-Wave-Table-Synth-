//
//  CV_lineDrawer.h
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CV_lineDrawer : UIView

@property (nonatomic) CGPoint chosenGesturePoint;
@property (nonatomic) CGPoint currentPoint;
@property BOOL drawChoosingLine;

@property BOOL xISConnected;
@property CGPoint xFrom;
@property CGPoint xTo;

@property BOOL yISConnected;
@property CGPoint yFrom;
@property CGPoint yTo;

@end
