//
//  EditableViewController.m
//  UICollectionViewDemo
//
//  Created by 讯心科技 on 2017/9/12.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "MultipleSelectedViewController.h"
#import "SelectCell.h"


@interface MultipleSelectedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *selectedDataArray;

@end


@implementation MultipleSelectedViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collectionView.allowsMultipleSelection = YES;// 设置多选
    
    self.flowLayout.itemSize     = CGSizeMake(80.0, 80.0);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    self.flowLayout.minimumLineSpacing      = 10.0;
    self.flowLayout.minimumInteritemSpacing = 10.0;
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i++)
    {
        NSString *string = [NSString stringWithFormat:@"row: %d",i];
        [self.dataArray addObject:string];
    }
}


#pragma mark- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor greenColor] : [UIColor cyanColor];
    
    return cell;
}

#pragma mark- UICollectionViewDelegate
// 多选时，可设置能否取消选中状态
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedDataArray addObject:self.dataArray[indexPath.row]];
    
    NSLog(@"已选中: %@",self.selectedDataArray);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedDataArray removeObject:self.dataArray[indexPath.row]];
    
    NSLog(@"已选中: %@",self.selectedDataArray);
}


- (NSMutableArray *)selectedDataArray
{
    if (_selectedDataArray == nil)
    {
        _selectedDataArray = [[NSMutableArray alloc] init];
    }
    return _selectedDataArray;
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
