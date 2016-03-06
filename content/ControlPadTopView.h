//
//  KaossControlView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_TypesAndHelpers.h"
#import "ControlPad_Element.h"

@protocol ControlPadTopViewDelegate <NSObject>
- (void)elementXButtonTapped;
- (void)elementYButtonTapped;
@end

@interface ControlPadTopView : UIView

@property (nonatomic,weak) id <ControlPadTopViewDelegate> delegate;

@property ControlPad_Element * elementX;
@property ControlPad_Element * elementY;
@property ControlPad_Element * selectedElement;

@property BOOL elementIsListening;

- (void)refreshElementButtonNames;

- (void)setElementXNameWithString:(NSString *)string;
- (void)setElementYNameWithString:(NSString *)string;

@end

