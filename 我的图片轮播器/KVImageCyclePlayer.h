//
//  KVCycleImagePlayer.h
//  我的图片轮播器
//
//  Created by 唐姚 on 16/4/18.
//  Copyright © 2016年 唐姚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KVImageCyclePlayer : UIView

/** 图片轮播时间间隔 */
@property (nonatomic,assign) NSTimeInterval timeInterval;
/** pageControl页标识前景颜色 */
@property (nonatomic,strong) UIColor * currentPageIndicatorTintColor;
/** pageControl页标识背景颜色 */
@property (nonatomic,strong) UIColor * pageIndicatorTintColor;
/** pageControl离视图底部距离(默认为0) */
@property (nonatomic,assign) CGFloat pageControlDistanceBottom;
/** 当前显示的页标 */
@property (nonatomic,assign) NSInteger currentShowPage;

/** 唯一初始化方法 */
- (instancetype) initWithImageNames:(NSArray *)imageNames;
/** 动画设置当前显示页面(默认从0开始) */
- (void) setCurrentPage:(NSInteger)currentPage animation:(BOOL)animation;
/** 设置当前显示页面(默认从0开始) */
- (void) setCurrentPage:(NSInteger)currentPage;
/** 添加点击响应事件（通过currenShowPage获取点击的index） */
- (void) addTarget:(id)target action:(SEL)action;

@end
