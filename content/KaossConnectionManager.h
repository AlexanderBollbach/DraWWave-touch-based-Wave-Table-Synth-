//
//  KaossManager.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KaossControlView.h"

@interface KaossConnectionManager : NSObject<KaossControlViewDelegate>

+ (instancetype)sharedInstance;

@end
