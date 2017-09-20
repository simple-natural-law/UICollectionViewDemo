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
    
    UILabel *label = [cell.contentView viewWithTag:10086];
    
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        return reusableView;
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        
        return reusableView;
    }
    
    return nil;
}


#pragma mark- UICollectionViewDelegateWaterfallsFlowLayout
- (CGFloat)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return arc4random()%100+50.0;
            break;
        case 1:
            return arc4random()%150+80.0;
            break;
        case 2:
            return arc4random()%200+120.0;
            break;
        default:
            return 0.0;
            break;
    }
}

- (NSInteger)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (CGSize)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return CGSizeMake(collectionView.frame.size.width, 30.0);
            break;
        case 1:
            return CGSizeMake(collectionView.frame.size.width, 20.0);
            break;
        case 2:
            return CGSizeMake(collectionView.frame.size.width, 40.0);
            break;
        default:
            return CGSizeMake(0.0, 0.0);
            break;
    }
}

- (CGSize)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return CGSizeMake(collectionView.frame.size.width, 30.0);
            break;
        case 1:
            return CGSizeMake(collectionView.frame.size.width, 20.0);
            break;
        case 2:
            return CGSizeMake(collectionView.frame.size.width, 40.0);
            break;
        default:
            return CGSizeMake(0.0, 0.0);
            break;
    }
}

- (CGFloat)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 10.0;
            break;
        case 1:
            return 20.0;
            break;
        case 2:
            return 30.0;
            break;
        default:
            return 10.0;
            break;
    }
}

- (CGFloat)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout rowSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 10.0;
            break;
        case 1:
            return 20.0;
            break;
        case 2:
            return 30.0;
            break;
        default:
            return 10.0;
            break;
    }
}


- (UIEdgeInsets)waterfallsCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
            break;
        case 1:
            return UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
            break;
        case 2:
            return UIEdgeInsetsMake(30.0, 30.0, 30.0, 30.0);
            break;
        default:
            return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
            break;
    }
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
