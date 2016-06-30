//
//  KVCycleImagePlayer.m
//  我的图片轮播器
//
//  Created by 唐姚 on 16/4/18.
//  Copyright © 2016年 唐姚. All rights reserved.
//

#import "KVImageCyclePlayer.h"

// 图片轮播器的宽高
#define viewW self.bounds.size.width
#define viewH self.bounds.size.height

@interface KVImageCyclePlayer()<UIScrollViewDelegate>

/** 滚动视图 */
@property (nonatomic,weak) UIScrollView * scrollView;
/** 页控制器 */
@property (nonatomic,weak) UIPageControl * pageControl;
/** 定时器 */
@property (nonatomic,strong) NSTimer * timer;
/** 图片名数组 */
@property (nonatomic,strong) NSArray * imageNames;
/** 图片张数 */
@property (nonatomic,assign) NSInteger count;
/** 当前显示的页面*/
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation KVImageCyclePlayer {
    id _target;
    SEL _action;
}

#pragma mark - 懒加载&setter
- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    if (timeInterval <= 0) {
        return;
    }
    _timeInterval = timeInterval;
    // 销毁上一次的定时器
    [self.timer invalidate];
    self.timer = nil;
    // 开启新的定时器
    [self timer];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setPageControlDistanceBottom:(CGFloat)pageControlDistanceBottom
{
    _pageControlDistanceBottom = pageControlDistanceBottom;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.count];
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center = CGPointMake(viewW * 0.5, viewH - self.pageControlDistanceBottom - 0.5 * size.height);
}

#pragma mark - 系统方法

- (instancetype) initWithImageNames:(NSArray *)imageNames
{
    self = [super init];
    if (self) {
        // 初始化默认数据
        self.timeInterval = 2.0;
        self.currentPage = 0;
        self.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControlDistanceBottom = 0;
        
        
        _imageNames = imageNames;
        self.count = imageNames.count;
        
        // 创建scrollView
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        
        // 添加UIPageControl
        UIPageControl * pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = NO;
        pageControl.numberOfPages = self.count;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置scrollView的frame
    self.scrollView.frame = self.bounds;
    // 设置scrollView的内容大小
    self.scrollView.contentSize = CGSizeMake((self.count + 2) * viewW, viewH);
    // 设置scrollView偏移到指定图片
    self.scrollView.contentOffset = CGPointMake(viewW * (self.currentPage + 1), 0);
    // 给scrollView添加子视图
    for (int i = 0; i < self.count + 2; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i * viewW, 0, viewW, viewH)];
        if (i == 0) {
            [button setBackgroundImage:[UIImage imageNamed:[self.imageNames lastObject]] forState:UIControlStateNormal];
        } else if (i == self.count + 1){
            [button setBackgroundImage:[UIImage imageNamed:[self.imageNames firstObject]] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:self.imageNames[i - 1]] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
        [self.scrollView addSubview:button];
    }

    // 设置pageControl的位置尺寸
    CGSize size = [self.pageControl sizeForNumberOfPages:self.count];
    self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    self.pageControl.center = CGPointMake(viewW * 0.5, viewH - self.pageControlDistanceBottom - 0.5 * size.height);
    // 设置pageControl的样式
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    // 设置pageControl首次展示的页面
    self.pageControl.currentPage = self.currentPage;
    // 设置第一次显示的页面
    self.pageControl.currentPage = self.currentPage;
    
    // 开启定时器
    [self timer];

}


#pragma mark - 自定义方法
- (void) addTarget:(id)target action:(SEL)action
{
    _action = action;
    _target = target;
    
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage < 0 || currentPage >= self.count) {
        return;
    }
    
    _currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
    self.scrollView.contentOffset = CGPointMake(viewW * (self.currentPage + 1), 0);
    
}

- (void) setCurrentPage:(NSInteger)currentPage animation:(BOOL)animation
{
    if (currentPage < 0 || currentPage >= self.count) {
        return;
    }
    
    _currentPage = currentPage;
    self.pageControl.currentPage = currentPage;
    [self.scrollView setContentOffset:CGPointMake(viewW * (currentPage + 1), 0) animated:YES];
}


#pragma mark - 响应事件
- (void) update
{
    NSInteger page = self.pageControl.currentPage + 1;
    [self.scrollView setContentOffset:CGPointMake(page * viewW + viewW, 0) animated:YES];
}

- (void) btnClick
{
    [_target performSelector:_action withObject:self];
}


#pragma mark - UIScrollViewDelegate
/**
 *  非拖拽滚动结束调用：判断是否为循环页
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == viewW * (self.count + 1)) {
        self.scrollView.contentOffset = CGPointMake(viewW, 0);
    } else if (self.scrollView.contentOffset.x == 0) {
        self.scrollView.contentOffset = CGPointMake(viewW * self.count, 0);
    }
    
    // 更新pageControl的页码
    double index = self.scrollView.contentOffset.x / viewW;
    self.pageControl.currentPage = index - 1;
    // 当前显示的页标
    self.currentShowPage = self.pageControl.currentPage;
}

/**
 *  拖拽滚动结束
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == viewW * (self.count + 1)) {
        self.scrollView.contentOffset = CGPointMake(viewW, 0);
    } else if (self.scrollView.contentOffset.x == 0) {
        self.scrollView.contentOffset = CGPointMake(viewW * self.count, 0);
    }
    
    // 更新pageControl的页码
    double index = scrollView.contentOffset.x / viewW;
    self.pageControl.currentPage = index - 1;
    
    // 当前显示的页标
    self.currentShowPage = self.pageControl.currentPage;
    
    // 实例化定时器
    [self timer];
}

/**
 *  拖拽开始的时候销毁定时器
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  拖拽滚动过程中实时更新pageControl的页码（采用四舍五入）
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double index = scrollView.contentOffset.x / viewW;
    NSInteger page = (index + 0.5) - 1;
    
    // 判断是否为循环页
    if (page < 0) {
        page = self.count;
    } else if (page > self.count - 1) {
        page = 0;
    }
    
    // 实时更新pageControl的页码
    self.pageControl.currentPage = page;
}


@end
