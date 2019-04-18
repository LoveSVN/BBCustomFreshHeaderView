//
//  BBCustomFreshHeaderView.h
//  BonreeBox
//
//  Created by bonree on 2019/4/8.
//  Copyright © 2019 Bonree. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>


typedef NS_ENUM(NSInteger, BBRefreshState) {
    /** 普通闲置状态 */
    BBRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    BBRefreshStatePulling,
    /** 正在刷新中的状态 */
    BBRefreshStateRefreshing,
    /** 即将刷新的状态 */
    BBRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    BBRefreshStateNoMoreData,
    BBRefreshStateCompleteSuccess,
    BBRefreshStateCompleteFail
};
NS_ASSUME_NONNULL_BEGIN

@interface BBCustomFreshHeaderView : MJRefreshComponent
/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;


/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;


#pragma mark - 状态相关
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(BBRefreshState)state;



//@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (weak, nonatomic, readonly) UIImageView *completeImageView;
@property(nonatomic,assign)BOOL requestSccuess;

@end

NS_ASSUME_NONNULL_END
