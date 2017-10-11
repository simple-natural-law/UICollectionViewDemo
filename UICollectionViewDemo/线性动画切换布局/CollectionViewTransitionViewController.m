//
//  CollectionViewTransitionViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/10/10.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "CollectionViewTransitionViewController.h"


@interface CollectionViewTransitionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayoutA;

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayoutB;

@end

@implementation CollectionViewTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    [button setTitle:@"切换" forState:UIControlStateNormal];
    [button setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeLayout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.collectionView.collectionViewLayout = self.flowLayoutA;
}

- (void)changeLayout
{
    if (self.collectionView.collectionViewLayout == self.flowLayoutB)
    {
        [self.collectionView setCollectionViewLayout:self.flowLayoutA animated:YES];
    }else
    {
        [self.collectionView setCollectionViewLayout:self.flowLayoutB animated:YES];
    }
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}


#pragma mark- 懒加载
- (UICollectionViewFlowLayout *)flowLayoutB
{
    if (_flowLayoutB == nil)
    {
        _flowLayoutB = [[UICollectionViewFlowLayout alloc] init];
        
        _flowLayoutB.itemSize = CGSizeMake(150.0, 150.0);
        
        _flowLayoutB.minimumLineSpacing = 10.0;
        
        _flowLayoutB.minimumInteritemSpacing = 10.0;
        
        _flowLayoutB.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }
    
    return _flowLayoutB;
}

- (UICollectionViewFlowLayout *)flowLayoutA
{
    if (_flowLayoutA == nil)
    {
        _flowLayoutA = [[UICollectionViewFlowLayout alloc] init];
        
        _flowLayoutA.itemSize = CGSizeMake(80.0, 80.0);
        
        _flowLayoutA.minimumLineSpacing = 10.0;
        
        _flowLayoutA.minimumInteritemSpacing = 10.0;
        
        _flowLayoutA.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    }
    
    return _flowLayoutA;
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
