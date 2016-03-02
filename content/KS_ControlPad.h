//
//  KaossControlView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_TypesAndHelpers.h"
#import "KS_ControlPad_Element.h"

@class KS_ControlPad;

@protocol KS_ControlPadDelegate <NSObject>
- (void)changedWithParameter:(KS_Parameter_t)parameter andValue:(float)value;
- (void)elementButtonTapped:(KS_Element_t)element;
@end

@interface KS_ControlPad : UIView

@property (nonatomic,weak) id <KS_ControlPadDelegate> delegate;

@property KS_ControlPad_Element * elementX;
@property KS_ControlPad_Element * elementY;



@property KS_ControlPad_Element * selectedElement;
@property BOOL elementIsListening;



@end

