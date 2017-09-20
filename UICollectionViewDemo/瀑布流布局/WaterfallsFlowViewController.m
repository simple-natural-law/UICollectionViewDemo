//
//  WaterfallsFlowViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/15.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "WaterfallsFlowViewController.h"
#import "WaterfallsFlowLayout.h"

@interface WaterfallsFlowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateWaterfallsFlowLayout>


@end


@implementation WaterfallsFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}


#pragma mark- UICollectionViewDelegateWaterfallsFlowLayout
- (CGFloat)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return arc4random()%150+50.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
