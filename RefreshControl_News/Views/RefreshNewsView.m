//
//  RefreshNewsView.m
//  RefreshControl_News
//
//  Created by POWER on 2016/11/19.
//  Copyright © 2016年 Control. All rights reserved.
//

#import "RefreshNewsView.h"

@interface RefreshNewsView ()

@property (nonatomic, strong) UILabel *newsLabel;

@end

@implementation RefreshNewsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:220/255.0 green:232.0/255.0 blue:244.0/255.0 alpha:1.0];
        [self initView];
    }
    return self;
}

- (void)resetLayoutSubViews
{
    self.backgroundColor = [UIColor colorWithRed:220/255.0 green:232.0/255.0 blue:244.0/255.0 alpha:1.0];
    self.alpha = 0;
}

- (UILabel *)newsLabel
{
    if (_newsLabel == nil) {
        _newsLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _newsLabel.textAlignment = NSTextAlignmentCenter;
        _newsLabel.font = [UIFont systemFontOfSize:14.0f];
        _newsLabel.textColor = [UIColor colorWithRed:69.0/255.0 green:141.0/255.0 blue:243.0/255.0 alpha:1.0];
    }
    
    return _newsLabel;
}

- (void)initView
{
    [self addSubview:self.newsLabel];
}

- (void)animationWithView:(UILabel *)view
                    Scale:(CGFloat)scale
                    Alpha:(CGFloat)alpha
                     Stop:(BOOL)stop
{
    view.alpha = alpha;
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         view.transform = CGAffineTransformMakeScale(scale, scale);
                         view.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         if (!stop && finished) {
                             [self animationWithView:view
                                               Scale:1/scale
                                               Alpha:1
                                                Stop:YES];
                         }
                     }];
    
}

- (void)showWithString:(NSString *)string
{
    self.newsLabel.text = string;
    self.alpha = 1;
    
    [self animationWithView:self.newsLabel
                      Scale:1.1f
                      Alpha:0
                       Stop:NO];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.alpha = 0;
                         
                     } completion:nil];
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
