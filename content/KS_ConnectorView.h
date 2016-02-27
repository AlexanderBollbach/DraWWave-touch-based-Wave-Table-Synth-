//
//  ControlsViewB.h
//  DraWave
//
//  Created by alexanderbollbach on 2/24/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KS_TypesAndHelpers.h"

@protocol KS_ConnectorViewDelegate <NSObject>

- (void)connectionMadeFromElement:(KS_Element_t)element toParameter:(KS_Parameter_t)parameter;
- (void)breakConnectionsForElement:(KS_Element_t)element;
@end

@interface KS_ConnectorView : UIView

@property (nonatomic,weak) id <KS_ConnectorViewDelegate> delegate;

@end
