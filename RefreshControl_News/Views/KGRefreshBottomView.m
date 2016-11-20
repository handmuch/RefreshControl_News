//
//  KGRefreshBottomView.m
//  kugou
//
//  Created by SapoWong on 15/12/31.
//  Copyright © 2015年 caijinchao. All rights reserved.
//

#import "KGRefreshBottomView.h"

static CGFloat  const kKGRefreshBottomViewImgRightSpace                        =      7;


@interface KGRefreshBottomView()

@end

@implementation KGRefreshBottomView


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    
    //    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];
    self.backgroundColor = [UIColor clearColor];
    
    _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped=YES;
    _activityIndicatorView.color= [UIColor lightGrayColor];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_activityIndicatorView];
    
    
    _promptLabel=[[UILabel alloc]init];
    _promptLabel.backgroundColor=[UIColor clearColor];
    _promptLabel.font=[UIFont systemFontOfSize:13];
    //    _promptLabel.textAlignment=NSTextAlignmentCenter;
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    
    
    
    [self resetViews];
    
    [self resetLayoutSubViews];
    
}

- (void)resetViews
{
    _promptLabel.text=@"上拉加载更多";
    if ([self.activityIndicatorView isAnimating])
    {
        [self.activityIndicatorView stopAnimating];
    }
    
}


- (void)resetLayoutSubViews
{
    NSArray * tempContraint=self.constraints;
    if ([tempContraint count]>0)
    {
        [self removeConstraints:tempContraint];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
        NSLayoutConstraint *pTop=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:13];
        NSLayoutConstraint *pCenterX=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self addConstraints:@[pTop,pCenterX]];
        
        /////
        NSLayoutConstraint * aTop=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10];
        NSLayoutConstraint * aRight=[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.promptLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-20];
        
        NSArray * aList=@[aTop,aRight];
        
        [self addConstraints:aList];
        
    }];

}
///松开可刷新
- (void)canEngageRefresh
{
    _promptLabel.text=@"松开即可加载";
    
}
///松开返回
- (void)didDisengageRefresh
{
    [self resetViews];
}
///开始刷新
- (void)startRefreshing
{
    _promptLabel.text=@"正在加载中...";
    [self.activityIndicatorView startAnimating];
    
}
///结束
- (void)finishRefreshing
{
    [self resetViews];
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
