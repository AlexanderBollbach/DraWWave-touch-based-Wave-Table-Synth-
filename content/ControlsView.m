//
//  ControlsView.m
//  WavformVizualizer_iOS
//
//  Created by alexanderbollbach on 2/18/16.
//  Copyright © 2016 alexanderbollbach. All rights reserved.
//

#import "ControlsView.h"
#import "functions.h"
#import "Global.h"
#import "ModeCollectionViewCell.h"

@interface ControlsView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView * modeCollView;
@property (nonatomic,strong) UICollectionView * paramCollView;

@property (nonatomic) float w;
@property (nonatomic) float h;

@property (nonatomic,strong) Global * global;



@end

@implementation ControlsView

- (instancetype)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      self.global = [Global sharedInstance];
      self.pulledDown = NO;
      
      
      self.w = CGRectGetWidth(self.bounds);
      self.h = CGRectGetHeight(self.bounds);
   }
   return self;
}


- (void)setup {
   
   
   CGRect modeFrame = CGRectMake(0,
                                 0,
                                 self.w,
                                 self.h * 0.5);
   CGRect paramFrame = CGRectMake(0,
                                  self.h * 0.5,
                                  self.w,
                                  self.h * 0.3);
   
   CGRect hudFrame = CGRectMake(0,
                                  self.h * 0.9,
                                  self.w,
                                  self.h * 0.1);

   UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
   layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   layout.minimumLineSpacing = 0;
   layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
   
   
   self.modeCollView = [[UICollectionView alloc] initWithFrame:modeFrame collectionViewLayout:layout];
   self.modeCollView.pagingEnabled = YES;
   [self.modeCollView setDataSource:self];
   [self.modeCollView setDelegate:self];
   self.modeCollView.backgroundColor = [UIColor clearColor];
   [self.modeCollView registerClass:[ModeCollectionViewCell class] forCellWithReuseIdentifier:@"mode"];
   [self addSubview:self.modeCollView];
   
   
   
   
   
   UICollectionViewFlowLayout * layout2 = [[UICollectionViewFlowLayout alloc] init];
   layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   layout2.minimumLineSpacing = 0;
   layout2.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
   
   self.paramCollView = [[UICollectionView alloc] initWithFrame:paramFrame collectionViewLayout:layout2];
   self.paramCollView.pagingEnabled = YES;
   [self.paramCollView setDataSource:self];
   [self.paramCollView setDelegate:self];
   self.paramCollView.backgroundColor = [UIColor clearColor];
   [self.paramCollView registerClass:[ModeCollectionViewCell class] forCellWithReuseIdentifier:@"param"];
   [self addSubview:self.paramCollView];
   
   
   
   
   self.hudLabel = [[UILabel alloc] initWithFrame:hudFrame];
   [self addSubview:self.hudLabel];
   self.hudLabel.textColor = [UIColor whiteColor];
   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

   if ([scrollView isEqual:self.modeCollView]) {
      CGPoint centerPoint = CGPointMake(self.modeCollView.frame.size.width / 2 + scrollView.contentOffset.x, self.modeCollView.frame.size.height /2 + scrollView.contentOffset.y);
      
      NSIndexPath * indexPath = [self.modeCollView indexPathForItemAtPoint:centerPoint];
      NSLog(@"%@", indexPath);
      
      [self.global.modeManager setActiveModeWithId:(int)indexPath.item];
      
      [self.paramCollView reloadData];
   }
   
   if ([scrollView isEqual:self.paramCollView]) {
      CGPoint centerPoint = CGPointMake(self.modeCollView.frame.size.width / 2 + scrollView.contentOffset.x, self.modeCollView.frame.size.height /2 + scrollView.contentOffset.y);
      
      NSIndexPath * indexPath = [self.modeCollView indexPathForItemAtPoint:centerPoint];
      NSLog(@"%@", indexPath);
      
      [self.global.modeManager.activeMode setActiveParameterWithId:(int)indexPath.item];
      
   }

   
   
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
   if ([collectionView isEqual:self.paramCollView]) {
      return CGSizeMake(self.w, collectionView.bounds.size.height);
   }
   if ([collectionView isEqual:self.modeCollView]) {
      return CGSizeMake(self.w, collectionView.bounds.size.height);
   }
   return CGSizeMake(10, 10);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
   if ([collectionView isEqual:self.modeCollView]) {
      NSInteger num = self.global.modeManager.allModes.count;
      return num;
   }
   
   
   
   if ([collectionView isEqual:self.paramCollView]) {
      NSInteger num = self.global.modeManager.activeMode.allParameters.count;
      return num;
   }
   
   return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   ModeCollectionViewCell * cell;
   
   if ([collectionView isEqual:self.modeCollView]) {
      cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mode" forIndexPath:indexPath];
      NSString * name = [self.global.modeManager getNameForMode:(int)indexPath.item];
      cell.name.text = name;
      
      //      if ([self.global.modeManager isModeActive:(int)indexPath.item]) {
      //         cell.layer.borderWidth = 1;
      //      } else {
      //         cell.layer.borderWidth = 0;
      //      }
      //
      
   }
   
   
   if ([collectionView isEqual:self.paramCollView]) {
      cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"param" forIndexPath:indexPath];
      NSString * name = [self.global.modeManager getNameForActiveParam:(int)indexPath.item];
      cell.name.text = name;
      
      //
      //      if ([self.global.modeManager.activeMode isParamActive:(int)indexPath.item]) {
      //         cell.layer.borderWidth = 1;
      //      } else {
      //         cell.layer.borderWidth = 0;
      //      }
      
   }
   
   return cell;
   
}



//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//   
//   if ([collectionView isEqual:self.modeCollView]) {
//   NSLog(@"%@", indexPath);
//   }
//
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
      if ([collectionView isEqual:self.modeCollView]) {
         [self.global.modeManager setActiveModeWithId:(int)indexPath.item];
      }
   
   
      if ([collectionView isEqual:self.paramCollView]) {
         [self.global.modeManager.activeMode setActiveParameterWithId:(int)indexPath.item];
      }
   //
   //   [self.modeCollView reloadData];
   //   [self.paramCollView reloadData];
   
}





@end
