//
//  ParameterView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_TypesAndHelpers.h"
#import "KS_ControlPad.h"

@interface KS_ElementButton : UIButton

@property (nonatomic,strong) UILabel * name;
@property (nonatomic) KS_Element_t element;


@property (nonatomic,assign) KS_ControlPad * owningControlPad;
- (void)animate:(BOOL)animate;


@end
