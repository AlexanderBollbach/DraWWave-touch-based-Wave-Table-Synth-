//
//  ParameterView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/25/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_TypesAndHelpers.h"

@interface KS_ElementView : UIView

@property (nonatomic,strong) UILabel * name;
@property (nonatomic) KS_Element_t element;

- (void)animate:(BOOL)animate;

@end
