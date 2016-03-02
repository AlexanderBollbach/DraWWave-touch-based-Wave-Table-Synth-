//
//  KS_SettingsButton.h
//  DraWave
//
//  Created by alexanderbollbach on 2/27/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_TypesAndHelpers.h"

@interface KS_SettingsButton : UIButton

@property settingsType_t type;

- (void)animate:(BOOL)animate;

@end
