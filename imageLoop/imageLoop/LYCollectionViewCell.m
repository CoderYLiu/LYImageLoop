//
//  LYCollectionViewCell.m
//  imageLoop
//
//  Created by liuya on 2017/8/9.
//  Copyright © 2017年 liuya. All rights reserved.
//

#import "LYCollectionViewCell.h"

@interface LYCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end


@implementation LYCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}


- (void)setImageitem:(NSString *)imageitem{

    _imageitem = imageitem;

    
    self.imageView.image = nil;
    
    self.imageView.image = [UIImage imageNamed:imageitem];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.pageControl.currentPage = self.tag;

    
}


@end


