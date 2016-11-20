//
//  RefreshControl.h
//
//  Copyright (c) 2014 YDJ ( https://github.com/ydj/RefreshControl )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

/**
 * 当前refreshing状态
 */
typedef enum {
    RefreshingDirectionNone    = 0,
    RefreshingDirectionTop     = 1 << 0,
    RefreshingDirectionBottom  = 1 << 1
} RefreshingDirections;

/**
 *  指定回调方向
 */
typedef enum {
    RefreshDirectionTop = 0,
    RefreshDirectionBottom
} RefreshDirection;


@protocol RefreshControlDelegate;


/**
 *	下拉刷新-上拉加载更多
 */
@interface RefreshControl : NSObject

///当前的状态
@property (nonatomic,assign,readonly)RefreshingDirections refreshingDirection;

@property (nonatomic,readonly)UIScrollView * scrollView;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIView *refreshNewsView;

//initTopView中，topview的高度默认加了80；如果需要加其他值，请设置customTopViewOffSet属性
@property (nonatomic, assign) int customTopViewOffSet;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<RefreshControlDelegate>)delegate;

///是否开启下拉刷新，YES-开启 NO-不开启 默认是NO
@property (nonatomic,assign)BOOL topEnabled;
///是否开启上拉加载更多，YES-开启 NO-不开启 默认是NO
@property (nonatomic,assign)BOOL bottomEnabled;
//是否有刷新消息提醒，YES-开启 NO-不开启 默认为NO
@property (nonatomic,assign)BOOL refreshViewEnabled;
///下拉刷新 状态改变的距离 默认70.0
@property (nonatomic,assign)float enableInsetTop;
///上拉 状态改变的距离 默认65.0
@property (nonatomic,assign)float enableInsetBottom;
//刷新消息高度，默认是refreshNewsView的高度，32，需要和refreshView的高度匹配，不然会出现UI问题
@property (nonatomic,assign)float enableRefreshHeight;

/*
 *是否开启自动刷新,下拉到enableInsetTop位置自动刷新
  YES-开启，NO-不开启，默认是NO
 */
@property (nonatomic,assign)BOOL autoRefreshTop;
/*
 * 是否开启自动加载更多，上拉到enableInsetBottom位置自动加载跟多
   YES-开启，NO-不开启，默认是NO
 */
@property (nonatomic,assign)BOOL autoRefreshBottom;
/*
    uiscrollerview 的系统默认偏移conentinset
 */
@property (nonatomic,assign)UIEdgeInsets sysDefaultInsetOfScroller;


/**
 *	注册Top加载的view,view必须接受RefreshViewDelegate协议,默认是RefreshTopView
 *	@param topClass 类类型
 */
- (void)registerClassForTopView:(Class)topClass;
/**
 *	注册Bottom加载的view,view必须接受RefreshViewDelegate协议,默认是RefreshBottomView
 *	@param bottomClass 类类型
 */
- (void)registerClassForBottomView:(Class)bottomClass;
/**
 *	注册RefreshNews加载的view,view必须接受RefreshViewDelegate协议,默认是WatchHomeRefreshNewsView
 *	@param refreshNewsClass 类类型
 */
- (void)registerClassForRefreshNewsView:(Class)refreshNewsClass;

- (void)finishTopRfreshWithString:(NSString *)string;

///开始
- (void)startRefreshingDirection:(RefreshDirection)direction;

///完成
- (void)finishRefreshingDirection:(RefreshDirection)direction;


@end


/**
 *	代理方法
 */
@protocol RefreshControlDelegate <NSObject>


@optional
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction;




@end



