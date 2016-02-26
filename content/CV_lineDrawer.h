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
@property BOOL stopDrawing;

@end
