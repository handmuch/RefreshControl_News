//
//  KGRefreshTopView.m
//  kugou
//
//  Created by Steven on 12/10/15.
//  Copyright © 2015 caijinchao. All rights reserved.
//

#import "KGRefreshTopView.h"
#import "UIImageTools.h"

@implementation KGRefreshTopView
{
    UIView *_bgView;
    NSMutableArray *_imageArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self initKgdogVidews];
    }
    
    return self;
}


- (void)initKgdogVidews
{
    self.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.clipsToBounds = YES;
    
    //把_bgView放在整个topview的最下
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-70, self.bounds.size.width, 70)];
    _bgView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_bgView];
    
    //酷小狗图片
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 65, 11, 48, 48)];
    
    _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i = 2; i < 4; i++) {
        //判断主题色调
            [_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"pullRefreshB_%d",i]]];
    }

    _imageView.image = [UIImage imageNamed:@"pullRefreshB_1.png"];
    
    _imageView.animationImages = _imageArray;
    _imageView.animationDuration = 0.6f;
    _imageView.animationRepeatCount = 0; //0为无限
    
    [_bgView addSubview:_imageView];
    
    _promptLabel = [[UILabel alloc]init];
    _promptLabel.frame = CGRectMake(_imageView.frame.origin.x + 48 + 10, 20, 160, 30);
    _promptLabel.backgroundColor = [UIColor clearColor];
    _promptLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    _promptLabel.textAlignment = NSTextAlignmentLeft;
    _promptLabel.font = [UIFont systemFontOfSize:14.0f];
    _promptLabel.text = @"下拉刷新";
    
    [_bgView addSubview:_promptLabel];
    
}

//重新布局
- (void)resetLayoutSubViews
{
    _imageView.image = [UIImage imageNamed:@"pullRefreshB_1.png"];
    
    _promptLabel.text = @"下拉刷新";
}

///松开可刷新
- (void)canEngageRefresh
{
    _promptLabel.text = @"释放刷新";
}
///松开返回
- (void)didDisengageRefresh
{
    _promptLabel.text = @"下拉刷新";
}

///开始刷新
- (void)startRefreshing
{
    //快速下拉时，直接设定views位置
    _promptLabel.text = @"加载中...";
//    _bgView.frame = CGRectMake(0, 80, self.width, 70);
//    _imageView.frame = CGRectMake(_bgView.centerX - 65, 11, 48, 48);
    [_imageView startAnimating];
}

///结束
- (void)finishRefreshing
{
    _promptLabel.text = @"加载完成";
    [_imageView stopAnimating];
}

- (void)dealloc
{
    //释放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
