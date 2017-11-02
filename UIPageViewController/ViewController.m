//
//  ViewController.m
//  UIPageViewController
//
//  Created by apple on 2017/11/2.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import "ViewController.h"
#import "ContentViewController.h"
@interface ViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic,strong)UIPageViewController * pageViewController;
@property(nonatomic,strong)NSArray * pageContentArray;

@end
//  UIPageViewController是iOS 5.0之后提供的一个分页控件可以实现图片轮播效果和翻书效果.使用起来也很简单方便.
@implementation ViewController
- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        for (int i = 1; i < 10; i++) {
            NSString *contentString = [[NSString alloc] initWithFormat:@"This is the page %d of content displayed using UIPageViewController", i];
            [arrayM addObject:contentString];
        }
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /* style :这个参数是UIPageViewController翻页的过渡样式,系统提供了两种过度样式,分别是
       1) UIPageViewControllerTransitionStylePageCurl : 卷曲样式类似翻书效果
       2) UIPageViewControllerTransitionStyleScroll : UIScrollView滚动效果
     *
     * navigationOrientation : 这个参数是UIPageViewController导航方向,系统提供了两种方式,分别是
         1) UIPageViewControllerNavigationOrientationHorizontal : 水平导航方式
         2) UIPageViewControllerNavigationOrientationVertical : 垂直导航方式

    
      * options : 这个参数是可选的,传入的是对UIPageViewController的一些配置组成的字典,不过这个参数只能以UIPageViewControllerOptionSpineLocationKey和UIPageViewControllerOptionInterPageSpacingKey这两个key组成的字典.
        1) UIPageViewControllerOptionSpineLocationKey 这个key只有在style是翻书效果UIPageViewControllerTransitionStylePageCurl的时候才有作用, 它定义的是书脊的位置,值对应着UIPageViewControllerSpineLocation这个枚举项,不要定义错了哦.
        2) UIPageViewControllerOptionInterPageSpacingKey这个key只有在style是UIScrollView滚动效果UIPageViewControllerTransitionStyleScroll的时候才有作用, 它定义的是两个页面之间的间距(默认间距是0).
 
     */
//    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]};

    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    ContentViewController * contentController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:contentController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    self.pageViewController.view.frame = self.view.bounds;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];


    
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    return [self viewControllerAtIndex:index];
    
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContentArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
    
}

#pragma mark 这个方法是UIPageViewController开始滚动或翻页的时候触发
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
}
#pragma mark 这个方法是UIPageViewController结束滚动或翻页的时候触发
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
}
//这个方法是在style是UIPageViewControllerTransitionStylePageCurl 并且横竖屏状态变化的时候触发,我们可以重新设置书脊的位置,比如如果屏幕是竖屏状态的时候我们就设置书脊位置是UIPageViewControllerSpineLocationMin或UIPageViewControllerSpineLocationMax, 如果屏幕是横屏状态的时候我们可以设置书脊位置是UIPageViewControllerSpineLocationMid
-(UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    return UIPageViewControllerSpineLocationMin;
}
//-(UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
//
//}
#pragma mark - 根据index得到对应的UIViewController

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    contentVC.content = [self.pageContentArray objectAtIndex:index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(ContentViewController *)viewController {
    return [self.pageContentArray indexOfObject:viewController.content];
}

@end
