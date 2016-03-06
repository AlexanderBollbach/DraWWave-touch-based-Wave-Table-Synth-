//
//  ParameterBankView.h
//  DraWave
//
//  Created by alexanderbollbach on 3/1/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_ParameterButton.h"

@protocol ControlPadParameterViewDelegate <NSObject>

- (void)parameterButtonTapped:(KS_Parameter_t)parameter;

@end

@interface ControlPadParameterVew : UIView

@property (nonatomic,weak) id <ControlPadParameterViewDelegate> delegate;

@end
