//
//  InsertAnimationViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/22.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "InsertAnimationViewController.h"
#import "CustomCell.h"


@interface InsertAnimationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end


@implementation InsertAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(insertItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

- (void)insertItem
{
    [self.dataArray insertObject:@"insert" atIndex:0];
    [self.dataArray insertObject:@"insert" atIndex:1];
    [self.dataArray insertObject:@"insert" atIndex:2];
    
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0],[NSIndexPath indexPathForItem:1 inSection:0],[NSIndexPath indexPathForItem:2 inSection:0]]];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    __weak InsertAnimationViewController *weakself = self;
    
    [cell deleteItemWithBlock:^(CustomCell *cell) {
        
        __strong InsertAnimationViewController *strongSelf = weakself;
        
        NSIndexPath *indexPath = [strongSelf.collectionView indexPathForCell:cell];
        
        [strongSelf.dataArray removeObjectAtIndex:indexPath.row];
        
        [strongSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}


-(NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 10; i++)
        {
            [_dataArray addObject:@(i)];
        }
    }
    return _dataArray;
}

@end
