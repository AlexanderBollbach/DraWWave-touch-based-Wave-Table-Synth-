//
//  ParameterView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParameterView : UIView

@property (nonatomic,strong) UILabel * name;

- (void)animate:(BOOL)animate;

@end
