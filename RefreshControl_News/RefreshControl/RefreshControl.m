//
//  RefreshControl.m
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

#import "RefreshControl.h"
#import "RefreshViewDelegate.h"
#import "KGRefreshTopView.h"
#import "KGRefreshBottomView.h"
#import "RefreshNewsView.h"

@interface RefreshControl ()

@property (nonatomic,weak)id<RefreshControlDelegate>delegate;

@property (nonatomic,copy)NSString * topClass;
@property (nonatomic,copy)NSString * bottomClass;
@property (nonatomic,copy)NSString * refreshNewsClass;

@property (nonatomic,copy)NSString * newsString;

@property (nonatomic,assign) BOOL isAnimationStop;

@end

@implementation RefreshControl


- (void)registerClassForTopView:(Class)topClass
{
    if ([topClass conformsToProtocol:@protocol(RefreshViewDelegate)]) {
        self.topClass=NSStringFromClass([topClass class]);
    }
    else{
        self.topClass=NSStringFromClass([KGRefreshTopView class]);
    }
}
- (void)registerClassForBottomView:(Class)bottomClass
{
    if ([bottomClass conformsToProtocol:@protocol(RefreshViewDelegate)]) {
        self.bottomClass=NSStringFromClass([bottomClass class]);
    }
    else{
        self.bottomClass=NSStringFromClass([KGRefreshBottomView class]);
    }
}
- (void)registerClassForRefreshNewsView:(Class)refreshNewsClass
{
    if ([refreshNewsClass conformsToProtocol:@protocol(RefreshViewDelegate)]) {
        self.refreshNewsClass=NSStringFromClass([refreshNewsClass class]);
    }
    else{
        self.refreshNewsClass=NSStringFromClass([RefreshNewsView class]);
    }
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<RefreshControlDelegate>)delegate
{
    self=[super init];
    if (self)
    {
        _scrollView=scrollView;
        _delegate=delegate;
        
        _topClass=NSStringFromClass([KGRefreshTopView class]);
        _bottomClass=NSStringFromClass([KGRefreshBottomView class]);
        _refreshNewsClass=NSStringFromClass([RefreshNewsView class]);
        
        self.enableInsetTop=70.0;
        self.enableInsetBottom=65.0;
        self.enableRefreshHeight=32.0;
        
        _sysDefaultInsetOfScroller =UIEdgeInsetsMake(0, 0, 0, 0);
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];
        
    }
    
    return self;
}

- (void)finishTopRfreshWithString:(NSString *)string
{
    self.newsString = string;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqual:@"contentSize"])
    {
        if (self.topEnabled)
        {
            [self initTopView];
        }
        
        if (self.bottomEnabled)
        {
            [self initBottonView];
        }
        
        if (self.refreshViewEnabled)
        {
            [self initRefreshNewsView];
        }
    }
    else if([keyPath isEqualToString:@"contentOffset"])
    {
        if (_refreshingDirection==RefreshingDirectionNone)
        {
            if (UIEdgeInsetsEqualToEdgeInsets(_sysDefaultInsetOfScroller,UIEdgeInsetsZero))
            {
                _sysDefaultInsetOfScroller = _scrollView.contentInset;
            }
            
            [self _drogForChange:change];
        }
    }
    
    if (self.topEnabled && self.topView.hidden == YES && self.scrollView.isTracking && !self.isAnimationStop) {
        
        [self pasueAnimation:self.scrollView];
        
    }else if(self.topEnabled && self.topView.hidden == YES && self.scrollView.isDecelerating && self.isAnimationStop){
        
        [self resumeAnimation:self.scrollView];
    }
}

- (void)_drogForChange:(NSDictionary *)change
{
    
    if ( self.topEnabled && self.scrollView.contentOffset.y<0)
    {
        if(self.scrollView.contentOffset.y<-self.enableInsetTop)
        {
            if (self.autoRefreshTop || ( self.scrollView.decelerating && self.scrollView.dragging==NO)) {
                [self _engageRefreshDirection:RefreshDirectionTop];
                
            }
            else{
                [self _canEngageRefreshDirection:RefreshDirectionTop];
            }
        }
        else
        {
            [self _didDisengageRefreshDirection:RefreshDirectionTop];
        }
    }
    
    if ( self.bottomEnabled && self.scrollView.contentOffset.y>0 )
    {
        
        if(self.scrollView.contentOffset.y>(self.scrollView.contentSize.height+self.enableInsetBottom-self.scrollView.bounds.size.height) )
        {
            if(self.autoRefreshBottom || (self.scrollView.decelerating && self.scrollView.dragging==NO)){
                [self _engageRefreshDirection:RefreshDirectionBottom];
            }
            else{
                [self _canEngageRefreshDirection:RefreshDirectionBottom];
            }
        }
        else {
            [self _didDisengageRefreshDirection:RefreshDirectionBottom];
        }
    }
}


- (void)_canEngageRefreshDirection:(RefreshDirection) direction
{
    if (direction==RefreshDirectionTop)
    {
        [self.topView performSelector:@selector(canEngageRefresh)];
        //[self.topView canEngageRefresh];
    }
    else if (direction==RefreshDirectionBottom)
    {
        [self.bottomView performSelector:@selector(canEngageRefresh)];
        //[self.bottomView canEngageRefresh];
    }
}

- (void)_didDisengageRefreshDirection:(RefreshDirection) direction
{
    
    if (direction==RefreshDirectionTop)
    {
        [self.topView performSelector:@selector(didDisengageRefresh)];
        //[self.topView didDisengageRefresh];
    }
    else if (direction==RefreshDirectionBottom)
    {
        [self.bottomView performSelector:@selector(didDisengageRefresh)];
        //[self.bottomView didDisengageRefresh];
    }
}


- (void)_engageRefreshDirection:(RefreshDirection) direction
{
    
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if (direction==RefreshDirectionTop)
    {
        _refreshingDirection=RefreshingDirectionTop;
        float topH=self.enableInsetTop<45?45:self.enableInsetTop;
        edge=UIEdgeInsetsMake(topH, 0, 0, 0);///enableInsetTop
        
    }
    else if (direction==RefreshDirectionBottom)
    {
        float botomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        edge=UIEdgeInsetsMake(_sysDefaultInsetOfScroller.top, 0, _sysDefaultInsetOfScroller.bottom +botomH, 0);///self.enableInsetBottom
        _refreshingDirection=RefreshingDirectionBottom;
        
    }
    // (top = 64, left = 0, bottom = 58, right = 0)

    _scrollView.contentInset=edge;
    
    [self _didEngageRefreshDirection:direction];
    
}

- (void)_didEngageRefreshDirection:(RefreshDirection) direction
{
    
    if (direction==RefreshDirectionTop)
    {
        [self.topView performSelector:@selector(startRefreshing)];
        //[self.topView startRefreshing];
    }
    else if (direction==RefreshDirectionBottom)
    {
        [self.bottomView performSelector:@selector(startRefreshing)];
        // [self.bottomView startRefreshing];
    }
    
    if ([self.delegate respondsToSelector:@selector(refreshControl:didEngageRefreshDirection:)])
    {
        [self.delegate refreshControl:self didEngageRefreshDirection:direction];
    }
    
    
}


- (void)_startRefreshingDirection:(RefreshDirection)direction animation:(BOOL)animation
{
    CGPoint point =CGPointZero;
    
    if (direction==RefreshDirectionTop)
    {
        float topH=self.enableInsetTop<45?45:self.enableInsetTop;
        point=CGPointMake(0, -topH);//enableInsetTop
    }
    else if (direction==RefreshDirectionBottom)
    {
        float height=MAX(self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        float bottomH=self.enableInsetBottom<45?45:self.enableInsetBottom;
        point=CGPointMake(0, height-self.scrollView.bounds.size.height+bottomH);///enableInsetBottom
    }
    __weak typeof(self)weakSelf=self;
    
    [_scrollView setContentOffset:point animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self)strongSelf=weakSelf;
        [strongSelf _engageRefreshDirection:direction];
    });
    
    
}

- (void)_finishRefreshingDirection1:(RefreshDirection)direction animation:(BOOL)animation
{
    if (direction == RefreshDirectionTop)
    {
        [self finishTopRefreshDirectionAction];
    }
    else if(direction==RefreshDirectionBottom)
    {
        [self finishBottomRefreshDirectionAction];
    }
}

- (void)finishTopRefreshDirectionAction
{
    
    if ([self isShowNewsEnableDirection:RefreshDirectionTop]) {
        [_scrollView setContentOffset:CGPointMake(0, -_enableInsetTop) animated:NO];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        UIEdgeInsets tmpInsets;
        if ([self isShowNewsEnableDirection:RefreshDirectionTop]) {
            tmpInsets = _sysDefaultInsetOfScroller;
            tmpInsets.top = _sysDefaultInsetOfScroller.top + self.enableRefreshHeight;
        }else{
            tmpInsets = _sysDefaultInsetOfScroller;
        }
        _scrollView.contentInset = tmpInsets;
        
        [self.topView performSelector:@selector(finishRefreshing)];
        
    } completion:^(BOOL finished) {
        
        if ([self isShowNewsEnableDirection:RefreshDirectionTop])
        {
            self.topView.hidden = YES;
            [self.refreshNewsView performSelector:@selector(showWithString:)
                                       withObject:self.newsString];
        }
        
        if ([self isShowNewsEnableDirection:RefreshDirectionTop]) {
            [UIView animateWithDuration:0.2
                                  delay:1.5
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 _scrollView.contentInset = _sysDefaultInsetOfScroller;
                             } completion:^(BOOL finished) {
                                 [self.refreshNewsView performSelector:@selector(dismiss)];
                                 self.topView.hidden = NO;
                                 self.newsString = nil;
                                 _refreshingDirection = RefreshingDirectionNone;
                             }];
        }else{
            _refreshingDirection = RefreshingDirectionNone;
        }
    }];
}

- (void)finishBottomRefreshDirectionAction
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _scrollView.contentInset= _sysDefaultInsetOfScroller;
        
        [self.bottomView performSelector:@selector(finishRefreshing)];
        
    } completion:^(BOOL finished) {
        
        _refreshingDirection = RefreshingDirectionNone;
    }];
}

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (BOOL)isShowNewsEnableDirection:(RefreshDirection)direction
{
    return self.refreshViewEnabled && direction==RefreshDirectionTop;
}

- (void)initTopView
{
    
    if (!CGRectIsEmpty(self.scrollView.frame))
    {
        float offsetHeight;

        if (self.customTopViewOffSet != 0) {
            offsetHeight = self.customTopViewOffSet;
        }
        else
        {
            offsetHeight = 80; //默认80
        }
        
        float topOffsetY=self.enableInsetTop+offsetHeight;
        
        if (self.topView==nil)
        {
            Class className=NSClassFromString(self.topClass);
            
            _topView=[[className alloc] initWithFrame:CGRectMake(0, -topOffsetY, self.scrollView.frame.size.width, topOffsetY)];
            [self.scrollView insertSubview:_topView belowSubview:self.scrollView];
        }
        else{
            if (self.scrollView.contentOffset.y > -self.enableInsetTop + 50) {

                _topView.frame=CGRectMake(0, -topOffsetY, self.scrollView.frame.size.width, topOffsetY);
                [_topView performSelector:@selector(resetLayoutSubViews)];
            }
        }
        
    }
    
}

- (void)initBottonView
{
    if (!CGRectIsNull(self.scrollView.frame))
    {
        float y=MAX(self.scrollView.bounds.size.height, self.scrollView.contentSize.height);
        if (self.bottomView==nil)
        {
            Class className=NSClassFromString(self.bottomClass);
            
            _bottomView=[[className alloc] initWithFrame:CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+45)];
            [self.scrollView addSubview:_bottomView];
        }
        else{
            _bottomView.frame=CGRectMake(0,y , self.scrollView.bounds.size.width, self.enableInsetBottom+45);
            
            [self.bottomView performSelector:@selector(resetLayoutSubViews)];
            //[self.bottomView resetLayoutSubViews];
        }
    }
}

- (void)initRefreshNewsView
{
    if (!CGRectIsNull(self.scrollView.frame)) {
        
        if (self.refreshNewsView==nil) {
            
            Class className=NSClassFromString(self.refreshNewsClass);
            _refreshNewsView=[[className alloc] initWithFrame:CGRectMake(0, -self.enableRefreshHeight, self.scrollView.bounds.size.width, self.enableRefreshHeight)];
            _refreshNewsView.alpha = 0;
            [self.scrollView insertSubview:_refreshNewsView belowSubview:self.scrollView];
        }else{
            _refreshNewsView.frame = CGRectMake(0, -self.enableRefreshHeight, self.scrollView.bounds.size.width, self.enableRefreshHeight);
            
            [_refreshNewsView performSelector:@selector(resetLayoutSubViews)];
        }
    }
}

- (void)setTopEnabled:(BOOL)topEnabled
{
    _topEnabled=topEnabled;
    
    if (_topEnabled)
    {
        if (self.topView==nil)
        {
            [self initTopView];
        }
        
    }
    else{
        [self.topView removeFromSuperview];
        self.topView=nil;
    }
    
}

- (void)setBottomEnabled:(BOOL)bottomEnabled
{
    _bottomEnabled=bottomEnabled;
    
    if (_bottomEnabled)
    {
        if (_bottomView==nil)
        {
            [self initBottonView];
        }
    }
    else{
        [_bottomView removeFromSuperview];
        _bottomView=nil;
    }
}

- (void)setRefreshViewEnabled:(BOOL)refreshViewEnabled
{
    _refreshViewEnabled = refreshViewEnabled;
    
    if (_refreshViewEnabled) {
        
        if (_refreshNewsView==nil) {
            
            [self initRefreshNewsView];
        }
    }
    else
    {
        [_refreshNewsView removeFromSuperview];
        _refreshNewsView = nil;
    }
}

- (void)startRefreshingDirection:(RefreshDirection)direction
{
    [self _startRefreshingDirection:direction animation:YES];
}

- (void)finishRefreshingDirection:(RefreshDirection)direction
{
    [self _finishRefreshingDirection1:direction animation:YES];
}

#pragma mark - Animation method

- (void)pasueAnimation:(UIView *)view
{
    CFTimeInterval pausedTime = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    view.layer.speed = 0.0;
    view.layer.timeOffset = pausedTime;
    self.isAnimationStop = YES;
}

- (void)resumeAnimation:(UIView *)view
{
    CFTimeInterval pausedTime = [view.layer timeOffset];
    view.layer.speed = 1.0;
    view.layer.timeOffset = 0.0;
    view.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    view.layer.beginTime = timeSincePause;
    self.isAnimationStop = NO;
}

@end
