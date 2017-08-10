//
//  ViewController.m
//  imageLoop
//
//  Created by liuya on 2017/8/9.
//  Copyright © 2017年 liuya. All rights reserved.
//

#import "ViewController.h"

#import "LYCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

// 类似一个保存模型的数组(里面存放图片,名称)
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, weak) NSTimer *timer;

@end

// 设置重用标识
static NSString *identifierCell = @"imageCell";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 创建collectionView
    [self creatCollectionView];
    
    // 初始化imagearray
    [self initImagearray];
    
}

// 数组里面添加数据
- (void)initImagearray{

    self.imageArray = @[@"img_01",@"img_02",@"img_03",@"img_04",@"img_05"];
    
    [self.collectionView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
}


//创建collectionView
- (void)creatCollectionView{
    
    
    // 创建好collectionView的布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置滚动方向为水平滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 130);
    
    // 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 130) collectionViewLayout:flowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"LYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifierCell];
    
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
}

#pragma mark - collectionView 的数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}


// 返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    // 缓冲池中取
    LYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    //当滚动的过程中item的值可能是 0 或者 2
    self.index = (self.currentIndex + indexPath.item - 1 + self.imageArray.count) % self.imageArray.count;
    cell.tag = self.index ;
    cell.imageitem = self.imageArray[self.index] ;
    
    NSLog(@"indexPath.item = %ld",indexPath.item);
    
    NSLog(@"self.index = %ld",self.index);

    return cell;
    
}


# pragma mark - collectionView 的代理方法
//滚动停止之后，把cell换成第二个cell
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //计算下一张图片的索引 (+1  -1)
    //返回的值始终是 （0  2） - 1
    int offset = scrollView.contentOffset.x / scrollView.bounds.size.width - 1;
    self.currentIndex = (self.currentIndex + offset + self.imageArray.count ) % self.imageArray.count;
    
    
    //始终显示第二个cell
    //主队列的执行特点：先等待主线程上的代码都执行完毕，再执行队列中的任务
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
        
        [self.collectionView reloadData];
    });
    
    
}


@end
