# 关于UICollectionView使用

## 概述

[UICollectionView](https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CollectionViewBasics/CollectionViewBasics.html#//apple_ref/doc/uid/TP40012334-CH2-SW7)是iOS开发中最常用的UI控件之一，我们可以使用它来管理一组有序的不同尺寸的视图，并以可自定制的布局来展示它们。UICollectionView还支持动画，当视图被插入，删除或重新排序时，就会触发动画，动画是支持自定义的。为了更好的使用UICollectionView，我们有必要对其进行深入了解。

## 基础
### UICollectionView是多个对象的协作
UICollectionView把视图要展现的数据以及数据的排列与视图的布局方式分开来管理。在开发过程中，开发者自行管理视图要展现的数据，而视图的布局呈现则由许多不同的对象来管理。下表列出了UIKit中的集合视图类，并根据它们在集合视图中的作用进行了划分。

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

## 实现一个简单的UICollectionView
UICollectionView必须拥有一个data source对象，data source对象提供了要显示的内容。它可以是一个数据模型对象，也可以是管理UICollectionView的视图控制器，data source对象的唯一要求是它必须能够提供UICollectionView所需的所有信息。delegate对象是可选的，用于管理与内容的呈现和交互。虽然delegate对象的主要职责是管理cell的选中和高亮状态，但可以扩展delegate以提供其他信息。例如，流布局就扩展了delegate对象行为来定制布局，例如，cell的大小和它们之间的间距。

### UICollectionViewDataSource
提供集合视图包含的section(分区)数量
```
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
return [_dataArray count];
}
```
提供每个section包含的item(单元格)数量
```
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section 
{
NSArray* sectionArray = [_dataArray objectAtIndex:section];
return [sectionArray count];
}
```
根据section和row提供对应的需要要显示的cell
```
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
cellForItemAtIndexPath:(NSIndexPath *)indexPath 
{
UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

return cell;
}
```
根据section和row提供对应的需要显示的supplementary view
```
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:@"A" withReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

return supplementaryView;
}
```
