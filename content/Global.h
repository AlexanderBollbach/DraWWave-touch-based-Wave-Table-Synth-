//
//  GOD.h
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ModeManager.h"

@protocol globalDelegate <NSObject>
- (void)showOnHUDDisplay:(NSString *)string;
@end



@interface Global : NSObject <ModeManagerDelegate>



@property (nonatomic,strong) id<globalDelegate> delegate;

@property (nonatomic,strong) ModeManager * modeManager;

+ (instancetype)sharedInstance;




@end



