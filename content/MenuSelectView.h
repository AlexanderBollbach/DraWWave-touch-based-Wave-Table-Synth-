//
//  MenuSelectView.h
//  DraWave
//
//  Created by alexanderbollbach on 3/2/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimatingButton.h"

@protocol MenuSelectViewDelegate <NSObject>

- (void)menuSelectButtonTappedWithId:(int)Id;

@end

@interface MenuSelectView : UIView

@property (nonatomic, weak) id <MenuSelectViewDelegate> delegate;


@property (nonatomic,strong) AnimatingButton * button1;
@property (nonatomic,strong) AnimatingButton * button2;
@property (nonatomic,strong) AnimatingButton * button3;
@property (nonatomic,strong) AnimatingButton * button4;

@end
