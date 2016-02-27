//
//  KaossManager.h
//  DraWave
//
//  Created by alexanderbollbach on 2/26/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KS_ControlPad.h"
#import "KS_Connection.h"

@protocol KS_ConnectionManagerDelegate <NSObject>
- (void)elementChangedWithParameter:(KS_Parameter_t)parameter andValue:(float)value;
@end

@interface KS_ConnectionManager : NSObject<KS_ControlPadDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic,strong) NSMutableArray * connections;

- (void)addConnectionWithKS_Element:(KS_Element_t)element andKS_Parameter:(KS_Parameter_t)parameter;
- (void)breakConnectionsWithElement:(KS_Element_t)element;

@property (nonatomic,weak) id <KS_ConnectionManagerDelegate> delegate;

@end
