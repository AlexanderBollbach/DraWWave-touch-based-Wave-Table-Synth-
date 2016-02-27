//
//  KS_ParameterView.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kaossTypes.h"

@interface KS_ParameterView : UIView

@property (nonatomic,strong) UILabel * name;
@property (nonatomic) KS_Parameter_t parameter;

- (void)animate:(BOOL)animate;

@end