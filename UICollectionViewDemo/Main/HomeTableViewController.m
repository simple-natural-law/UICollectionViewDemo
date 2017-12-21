//
//  HomeTableViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/5.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "HomeTableViewController.h"
#import "APLTransitionManager.h"
#import "APLStackLayout.h"
#import "APLStackCollectionViewController.h"


@interface HomeTableViewController ()<APLTransitionManagerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) APLTransitionManager *transitionManager;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UICollectionView使用";
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
    self.dataSource = @[@{@"title":@"简单的Collection View", @"target":@"BaseDemoViewController"},
                        @{@"title":@"可多选的Collection View", @"target":@"MultipleSelectedViewController"},
                        @{@"title":@"插入，删除和移动Cell", @"target":@"InsertViewController"},
                        @{@"title":@"剪切，复制和粘贴Cell", @"target":@"EditViewController"},
                        @{@"title":@"不规则瀑布流", @"target":@"WaterfallsFlowViewController"},
                        @{@"title":@"自定义Cell插入和删除动画", @"target":@"InsertAnimationViewController"},
                        @{@"title":@"类似iCarousel卡片切换效果", @"target":@"CardSelectedViewController"},
                        @{@"title":@"线性动画切换布局", @"target":@"CollectionViewChangeLayoutViewController"},
                        @{@"title":@"控制器跳转时布局切换转场动画", @"target":@"APLStackCollectionViewController"}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.transitionManager.delegate = self;
    
    self.transitionManager = nil;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.dataSource.count - 1)
    {
        APLStackLayout *stackLayout = [[APLStackLayout alloc] init];
        APLStackCollectionViewController *collectionViewController = [[APLStackCollectionViewController alloc] initWithCollectionViewLayout:stackLayout];
        collectionViewController.title = @"控制器跳转时布局切换转场动画";
        
        self.transitionManager =
        [[APLTransitionManager alloc] initWithCollectionView:collectionViewController.collectionView];
        self.transitionManager.delegate = self;
        
        [self.navigationController pushViewController:collectionViewController animated:YES];
    }else
    {
        UIViewController *targetVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:self.dataSource[indexPath.row][@"target"]];
        
        [self.navigationController pushViewController:targetVC animated:YES];
    }
}

#pragma mark - APLTransitionControllerDelegate

- (void)interactionBeganAtPoint:(CGPoint)p
{
    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op.
    //
    UIViewController *viewController =
    [(APLCollectionViewController *)self.navigationController.topViewController nextViewControllerAtPoint:p];
    if (viewController != nil)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    // return our own transition manager if the incoming controller matches ours
    if (animationController == self.transitionManager)
    {
        return self.transitionManager;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    id transitionManager = nil;
    
    // make sure we are transitioning from or to a collection view controller, and that interaction is allowed
    if ([fromVC isKindOfClass:[UICollectionViewController class]] &&
        [toVC isKindOfClass:[UICollectionViewController class]] &&
        self.transitionManager.hasActiveInteraction)
    {
        self.transitionManager.navigationOperation = operation;
        transitionManager = self.transitionManager;
    }
    return transitionManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
