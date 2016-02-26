//
//  ControlsView.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ControlsView : UIView
@property (nonatomic) BOOL pulledDown;

@property (nonatomic,strong) UILabel * hudLabel;

- (void)setup;
@end
