//
//  MenuView.h
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterBankView.h"

#import "DraWave-Swift.h"
#import "MenuSelectView.h"

@interface MenuView : UIView
@property (nonatomic,strong) ParameterBankView * parameterBankView;
@property (nonatomic,strong) ABScene * abScene;
@property (nonatomic,strong) MenuSelectView * menuSelectView;

@end
