# 关于UICollectionView使用

## 概述

[UICollectionView](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CollectionViewBasics/CollectionViewBasics.html#//apple_ref/doc/uid/TP40012334-CH2-SW7)是iOS开发中最常用的UI控件之一，我们可以使用它来管理一组有序的不同尺寸的视图，并以可定制的布局来展示它们。UICollectionView还支持动画，当视图被插入，删除或重新排序时，就会触发动画，动画是支持自定义的。为了更好的使用UICollectionView，我们有必要对其进行深入了解。

## 基础
### UICollectionView是由多个对象协作实现的
UICollectionView将视图要展现的数据以及数据的排列与视图的布局方式分开来管理。视图的数据内容有我们自行管理，而视图的布局呈现则由许多不同的对象来管理。下表列出了UIKit中的集合视图类，并根据它们在集合视图中的作用进行了划分。

| 目的 | 类/协议 | 描述 |
|-----|--------|------|
| 顶层容器和管理者 | UICollectionView UICollectionViewController | UICollectionView定义了显示视图内容的空间，它继承自[UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview)，能够根据内容的高度来调整其滚动区域。它的layout布局对象会提供布局信息来呈现数据。UICollectionViewController对象提供了一个UICollectionView的视图控制器级管理支持。 |
| 内容管理 | UICollectionViewDataSource协议 UICollectionViewDelegate协议 | DataSource协议是最重要的且必须遵循实现，它创造并管理UICollectionView的视图内容。Delegate协议能获取视图的信息并自定义视图的行为，这个协议是可选的。|
| 内容视图 | UICollectionReusableView UICollectionViewCell | UICollectionView展示的所有视图都必须是UICollectionReusableView类的实例，该类支持回收复用机制。回收复用视图而不是重新创建，在视图滚动时，能极大提高性能。 UICollectionViewCell对象是用来展示主要数据的可重用视图,该类继承自UICollectionReusableView。|
| 布局 | UICollectionViewLayout UICollectionViewLayoutAttributes UICollectionViewUpdateItem | UICollectionViewLayout的子类被称为布局对象，它负责定义集合视图中的cell和可重用视图的位置，大小，视觉效果。在布局过程中，布局对象UICollectionViewLayout会创建一个布局属性对象UICollectionViewLayoutAttributes去告诉集合视图在什么位置，用什么样视觉外观去展示cell和可重用视图。当在集合视图中插入，删除，移动数据项时，布局对象会接收到UICollectionViewUpdateItem类的实例，我们不需要自行创建该类的实例。|
| 流布局  | UICollectionViewFlowLayout UICollectionViewDelegateFlowLayout协议 |  UICollectionViewFlowLayout类是用于实现网格或其他基于行的布局的具体布局对象。 我们可以按照原样使用该类或者配合UICollectionViewDelegateFlowLayout协议一起使用，这样就可以动态自定义布局信息。|


上表展示了与UICollectionView相关联的核心对象之间的关系。UICollectionView从它的data source对象中获取要展示的cell的信息。我们需要自行提供data source和delegate对象去管理cell的内容，包括cell的选中和高亮等状态。布局对象负责决定cell所在的位置，布局属性对象负责决定cell的视觉效果属性，它们将布局属性对象传递给UICollectionView，UICollectionView接收到布局信息后创建并展示Cell。


![图1-1](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/Art/cv_objects_2x.png)

### 重用视图提高性能
UICollectionView通过复用已被回收的单元视图来提高效率，当单元视图滚动到屏幕外时，它们不会被删除，但会被移出容器视图并放置到重用队列中。当有新的内容将要滚动到屏幕中时，如果重用队列中有可复用的单元视图，会首先从重用队列中取，并重置被取出来的单元视图的数据，然后将其添加到容器视图中展示。如果重用队列没有可复用的单元视图，这时才会新创建一个单元视图去展示。为了方便这种循环，UICollectionView中展示的单元视图都必须继承自UICollectionReusableView类。

UICollectionView支持三种不同类型的可重用视图，每种视图都具有特定的用途：

- cell(单元格)展示UICollectionView的主要内容，每个cell展示内容来自与我们提供的data source对象。每个cell都必须是UICollectionViewCell的实例，同时我们也可以根据需要对其子类化。cell对象支持管理自己的选中和高亮状态。

- supplementary view(补充视图)展示每个section(分区)的信息。和cell相同的是，supplementary view也是数据驱动的。不同的是，supplementary view是可选的而不是强制的。supplementary view的使用和布局是由布局对象管理的，系统提供的流布局就支持设置header和footer作为可选的supplementary view。

- decoration view(装饰视图)与data source对象提供的数据不相关，完全属于布局对象。布局对象可能会使用它来实现自定义背景外观。

### 布局对象控制视图的视觉效果
布局对象负责确定UICollectionView中每个单元格(item)的位置和视觉样式。虽然data source对象提供了要展示的视图和实际内容，但布局对象确定了这些视图的位置，大小以及其他与外观相关的属性。这种责任划分使得我们能够动态的更改布局，而无需更改data source对象提供的数据。

布局对象并不拥有任何视图，它只会生成用来描述cell，supplementary view和decoration view的位置，大小，视觉样式的属性，并将这些属性传递给UICollectionView，UICollectionView将这些属性应用于实际的视图对象。

布局对象可以随意生成视图的位置，大小以及视觉样式属性，没有任何限制。只有布局对象能改变视图在UICollectionView中的位置，它能移动视图，也能随机切换横竖屏，甚至能复位某视图而不用考虑此视图周围的视图。例如，如果有需要，布局对象可以将所有视图叠加在一起。

下图显示了垂直滚动的流布局对象如何布置cell。在垂直滚动流布局中，内容区域的宽度保持固定，高度随着内容高度的增加而增加。布局对象一次只放置一个cell，在放置前会先计算出cell在容器视图中的frame，为cell选择最合适的位置。

![图1-2](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/Art/cv_layout_basics_2x.png)

## 实现一个简单的Collection View
我们必须为CollectionView提供一个data source对象，它为UICollectionView提供了要显示的内容。它可以是一个数据模型对象，也可以是管理UICollectionView的视图控制器，data source对象的唯一要求是它必须能够提供UICollectionView所需的所有信息。delegate对象是可选的，用于管理和内容的呈现以及交互有关的方面。delegate对象的主要职责是管理cell的选中和高亮状态，可以扩展delegate以提供其他信息。流布局对象就扩展了delegate对象行为来定制布局，例如，cell的大小和它们之间的间距。

### UICollectionViewDataSource
提供集合视图包含的section(分区)数量：
```
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
return [_dataArray count];
}
```
提供每个section包含的item(单元格)数量：
```
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section 
{
NSArray* sectionArray = [_dataArray objectAtIndex:section];
return [sectionArray count];
}
```
根据IndexPath提供需要显示的cell：
```
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath 
{
UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

return cell;
}
```
根据IndexPath提供需要显示的supplementary view，流布局的supplementary view分为Header和Footer两种类型：
```
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
// UICollectionElementKindSectionHeader返回Header，UICollectionElementKindSectionFooter返回Footer
if ([kind isEqualToString:UICollectionElementKindSectionHeader])
{
UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderReuseIdentifier" forIndexPath:indexPath];

return supplementaryView;
}else 
{
UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterReuseIdentifier" forIndexPath:indexPath];

return supplementaryView;
}
}
```

### UICollectionViewDelegate
设置cell是否能被选中(点击是否有效)：
```
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
return YES;
}
```
当collectionView的allowsMultipleSelection(多选)属性为YES时，设置是否可以点击取消选中已被选中的cell：
```
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
return NO;
}
```
已选中cell时，可以在此方法中执行我们想要的操作：
```
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
```
已取消选中cell时，可以在此方法中执行我们想要的操作：
```
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
```
设置cell被选中时是否支持高亮：
```
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
return YES;
}
```
选中cell时触发高亮，会调用这个方法，我们可以在这里去改变cell的背景色:
```
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

cell.contentView.backgroundColor = [UIColor lightGrayColor];
}
```
cell被取消选中变为普通状态后，会调用这个方法，我们可以在这里还原cell的背景色：
```
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

cell.contentView.backgroundColor = [UIColor whiteColor];
}
```
> 注意，点击cell时，cell的状态变化过程为：手指接触屏幕时，cell状态变为高亮，此时cell还未被选中。当手指离开屏幕后，cell状态变回到普通状态，然后cell被Collection View选中。当快速点击选中cell时，由于状态变化很快，导致人眼看不出来cell背景色有发生变化，实际上是发生了变化的。而长按选中cell时，可以看到背景色的变化。

![图2-1](http://oaz007vqv.bkt.clouddn.com/cell_selection_semantics_2x.png?imageView/2/w/600)

### UICollectionViewDelegateFlowLayout
该协议是对`UICollectionViewDelegate`的扩展，能够动态返回cell的大小，和cell之间的间距等。

根据IndexPath返回对应的Cell的大小：
```
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
return CGSizeMake(80.0, 80.0);
}
```
根据Section返回对应的cell到Collection View到四周边界的距离：
```
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
return UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
}
```
根据Section返回对应的cell之间的行间距：
```
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
return 10.0;
}
```
根据section返回对应的cell之间的列间距：
```
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
return 10.0;
}
```
根据section返回对应的Header大小
```
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
return CGSizeMake(collectionView.frame.size.width, 40.0);
}
```
根据section返回对应的Footer大小
```
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
return CGSizeMake(collectionView.frame.size.width, 40.0);
}
```

> 如果Collection View使用流布局，当cell的大小，cell之间的间距，cell到Collection View四周的边距，Header和Footer的大小固定时，可以直接设置`UICollectionViewFlowLayout`对象的`itemSize`，`minimumLineSpacing`，`minimumInteritemSpacing`，`sectionInset`，`headerReferenceSize`，`footerReferenceSize`属性，这样能够提高程序的运行效率。

### cell和supplementary view的重用
视图的重用避免了不断生成和销毁对象的操作，提高了程序运行的效率。要想重用cell和supplementary view，首先需要注册cell和supplementary view，有种三种注册方式：

- 使用storyboard布局时，直接拖拽cell或者supplementary view到storyboard中，设置好重用标识即可。

- 使用xib布局时，设置重用标识后，使用`- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier`方法来注册cell，使用`- (void)registerNib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier`方法来注册supplementary view。

- 使用代码布局时，使用`- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier`方法来注册cell，使用`- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier`方法来注册supplementary view。

> 使用纯代码自定义cell和supplementary view时，需要重写`- (instancetype)initWithFrame:(CGRect)frame`方法，`- (instancetype)init`方法不会被调用。

data source对象为UICollectionView配置cell和supplementary view时，使用`- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath`方法直接从重用队列中取cell，使用`- (UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath`方法直接从重用队列中取supplementary view。当重用队列中没有可复用的视图时，会自动帮我们新创建一个可用的视图。

### cell的插入，删除和移动
插入，删除，移动单个cell或者某个section的所有cell时，遵循下面两个步骤：

- 更新数据源对象中的数据内容。
- 调用对应的插入，删除或者移动方法。

Collection View插入，删除和移动cell之前，必须先对应更新数据源。如果数据源没有更新，程序运行就会崩溃。

当插入，删除或者移动cell时，会自动添加动画效果来反映Collection View的更改。在执行动画时如果还需要`同步`执行其他操作，可以使用`- (void)performBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion`方法，在`updates block`内执行所有插入，删除或移动调用，动画执行完毕后会调用`completion block`。
```
[self.collectionView performBatchUpdates:^{

NSArray* itemPaths = [self.collectionView indexPathsForSelectedItems];
// 删除数据源中的数据
[self deleteItemsFromDataSourceAtIndexPaths:itemPaths];
// 更新Collection View
[self.collectionView deleteItemsAtIndexPaths:itemPaths];
} completion:^(BOOL finished){

if (finished)
{
// 执行其他操作
}
}];
```
