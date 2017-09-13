//
//  EditableViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/12.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "MultipleSelectedViewController.h"

@interface MultipleSelectedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end


@implementation MultipleSelectedViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.flowLayout.itemSize     = CGSizeMake(80.0, 80.0);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    self.flowLayout.minimumLineSpacing      = 10.0;
    self.flowLayout.minimumInteritemSpacing = 10.0;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor greenColor] : [UIColor cyanColor];
    
    return cell;
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
