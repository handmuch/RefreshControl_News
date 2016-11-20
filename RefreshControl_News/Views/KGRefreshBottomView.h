//
//  KGRefreshBottomView.h
//  kugou
//
//  Created by SapoWong on 15/12/31.
//  Copyright © 2015年 caijinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

@interface KGRefreshBottomView : UIView<RefreshViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic,strong)UILabel *loadingLabel;//正在加载...
@property (nonatomic,strong)UILabel *promptLabel;//上拉加载更多

- (void)resetLayoutSubViews;
///松开可刷新
- (void)canEngageRefresh;
///松开返回
- (void)didDisengageRefresh;
///开始刷新
- (void)startRefreshing;
///结束
- (void)finishRefreshing;

@end
