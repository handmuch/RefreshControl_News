//
//  RefreshNewsView.h
//  RefreshControl_News
//
//  Created by POWER on 2016/11/19.
//  Copyright © 2016年 Control. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

@interface RefreshNewsView : UIView<RefreshViewDelegate>

- (void)resetLayoutSubViews;
- (void)showWithString:(NSString *)string;
- (void)dismiss;

@end
