//
//  BBCustomFreshHeaderView.m
//  BonreeBox
//
//  Created by bonree on 2019/4/8.
//  Copyright © 2019 Bonree. All rights reserved.
//

#import "BBCustomFreshHeaderView.h"


@interface BBCustomFreshHeaderView () {
    
    __unsafe_unretained UIImageView *_arrowView;
//    /** 显示上一次刷新时间的label */
//    __unsafe_unretained UILabel *_lastUpdatedTimeLabel;
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
    
    __unsafe_unretained UIImageView * _completeImageView;
}

@property (assign, nonatomic) CGFloat insetTDelta;

/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation BBCustomFreshHeaderView


#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mj_label]];
    }
    return _stateLabel;
}

- (UIImageView *)completeImageView {
    
    if (!_completeImageView) {
        UIImageView *completeImageView = [[UIImageView alloc] init];
        NSString *imageName = BBRefreshStateCompleteSuccess?@"RequestSuccess":@"RequestFail";
        completeImageView.image = [UIImage imageNamed:imageName];
        completeImageView.hidden = YES;
        [self addSubview:_completeImageView = completeImageView];
    }
    return _completeImageView;
}

//- (UIImageView *)arrowView
//{
//    if (!_arrowView) {
//        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle mj_arrowImage]];
//        [self addSubview:_arrowView = arrowView];
//    }
//    return _arrowView;
//}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma mark - 公共方法
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(BBRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}



#pragma mark - 覆盖父类的方法

#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 覆盖父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置高度
    self.mj_h = MJRefreshHeaderHeight;
    
    
    // 初始化间距
    self.labelLeftInset = MJRefreshLabelLeftInset;
    
    // 初始化文字
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderIdleText] forState:BBRefreshStateIdle];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderPullingText] forState:BBRefreshStatePulling];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderRefreshingText] forState:BBRefreshStateRefreshing];
    
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    
    [self setTitle:@"下拉刷新" forState:BBRefreshStateIdle];
    [self setTitle:@"释放更新" forState:BBRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:BBRefreshStateRefreshing];
    [self setTitle:@"请求成功" forState:BBRefreshStateCompleteSuccess];
    [self setTitle:@"请求失败" forState:BBRefreshStateCompleteFail];
    
//    self.stateLabel.textColor = RGB_X(0x6c95ff);
    self.stateLabel.textColor = [UIColor whiteColor];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    self.loadingView.color = RGB_X(0x6c95ff);
    self.loadingView.color = [UIColor whiteColor];
//    self.arrowView.hidden = YES;
    self.labelLeftInset = 15;
    
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
    
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    

    self.stateLabel.frame = self.bounds;
    
    
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        arrowCenterX -= textWidth / 2 + self.labelLeftInset;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    
    // 完成状态
    if (self.completeImageView.constraints.count == 0) {
        self.completeImageView.mj_size = self.completeImageView.image.size;
        self.completeImageView.center = arrowCenter;
    }
    
    // 箭头
//    if (self.arrowView.constraints.count == 0) {
//        self.arrowView.mj_size = self.arrowView.image.size;
//        self.arrowView.center = arrowCenter;
//    }
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
//    self.arrowView.tintColor = self.stateLabel.textColor;
    
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mj_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.mj_inset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(BBRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == BBRefreshStateIdle) {
        
        if (oldState == BBRefreshStateCompleteSuccess || oldState == BBRefreshStateCompleteFail) {
//            self.arrowView.hidden = YES;
            self.stateLabel.hidden = YES;
            self.loadingView.hidden = YES;
            self.completeImageView.hidden = YES;
            // 恢复inset和offset
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.scrollView.mj_insetT += self.insetTDelta;
                
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
                
                self.loadingView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != BBRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
//                self.arrowView.hidden = NO;
//                self.arrowView.image = [NSBundle mj_arrowImage];
                
            }];
            
            
            
        } else {
            
            [self.loadingView stopAnimating];
//            self.arrowView.hidden = NO;
            self.stateLabel.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//                self.arrowView.transform = CGAffineTransformIdentity;
            }];
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
        
    } else if (state == BBRefreshStateRefreshing) {
        
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
//        self.arrowView.hidden = YES;
        self.stateLabel.hidden = NO;
        
        MJRefreshDispatchAsyncOnMainQueue({
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                    CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
                    // 增加滚动区域top
                    self.scrollView.mj_insetT = top;
                    // 设置滚动位置
                    CGPoint offset = self.scrollView.contentOffset;
                    offset.y = -top;
                    [self.scrollView setContentOffset:offset animated:NO];
                }
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        })
    } else if (state == BBRefreshStatePulling) {
        [self.loadingView stopAnimating];
//        self.arrowView.hidden = NO;
        self.stateLabel.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == BBRefreshStateCompleteSuccess || state == BBRefreshStateCompleteFail) {
        [self.loadingView stopAnimating];
//        self.arrowView.transform = CGAffineTransformIdentity;
//        self.arrowView.hidden = NO;
        self.completeImageView.hidden = NO;
        self.stateLabel.hidden = NO;
        NSString *imageName = state == BBRefreshStateCompleteSuccess?@"RequestSuccess":@"RequestFail";
        self.completeImageView.image = [UIImage imageNamed:imageName];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            MJRefreshDispatchAsyncOnMainQueue(self.state = BBRefreshStateIdle;)
        });
        
    
    }
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
}


- (void)setIgnoredScrollViewContentInsetTop:(CGFloat)ignoredScrollViewContentInsetTop {
    _ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    
    self.mj_y = - self.mj_h - _ignoredScrollViewContentInsetTop;
}

-(void)endRefreshing {
    
    if ([self isRefreshing]) {
       
        self.state = self.requestSccuess?BBRefreshStateCompleteSuccess:BBRefreshStateCompleteFail;
    }
    
    
}

@end
