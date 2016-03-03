//
//  AnimatingButton.h
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatingButton : UIButton

@property (nonatomic,strong) NSString * typeName;
@property (nonatomic,strong) UILabel * title;

- (void)animate:(BOOL)animate;

@end
