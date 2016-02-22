//
//  ControlsView.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlsViewDelegate <NSObject>
//- (void)changeEffectOnMode:(int)mode withValue:(float)value;
//- (void)scrollRight;
//- (void)scrollLeft;
- (void)modeButtonTapped:(int)tag;

@end

@interface ControlsView : UIView
@property (nonatomic,strong) id<ControlsViewDelegate> delegate;
@property (nonatomic) BOOL pulledDown;



@end
