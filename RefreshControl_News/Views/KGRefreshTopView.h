//
//  KGRefreshTopView.h
//  kugou
//
//  Created by Steven on 12/10/15.
//  Copyright © 2015 caijinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

@interface KGRefreshTopView : UIView<RefreshViewDelegate>

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *promptLabel;

///重新布局
- (void)resetLayoutSubViews;

///松开可刷新
- (void)canEngageRefresh;
///松开返回
- (void)didDisengageRefresh;
///开始刷新
- (void)startRefreshing;
///结束
- (void)finishRefreshing;

- (void)drawTopScrollViewWith:(NSNumber *)contentOffsetY;

@end
