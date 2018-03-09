//
//  GroupZuWeiCell.m
//  JRMedical
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "GroupZuWeiCell.h"
#import "CCThreeItem.h"
#import "GZuWeiModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation GroupZuWeiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changimage:) name:@"changefangxian" object:nil];
    NSLog(@"------------------zoule");
    [_morebt setImage:[UIImage imageNamed:@"comment_arrow_down@2x"]  forState:(UIControlStateNormal)];
//    [_morebt setImage:[UIImage imageNamed:@"channel_nav_arrow@2x"] forState:(UIControlStateNormal)];
    [self configureCollectionView];
}

- (void)changimage:(NSNotification*)sender {

    if ([sender.userInfo[@"ture"] isEqualToString:@"nihao"]) {
        [_morebt setImage:[UIImage imageNamed:@"channel_nav_arrow@2x"] forState:(UIControlStateNormal)];
    } else {
      
        [_morebt setImage:[UIImage imageNamed:@"comment_arrow_down@2x"]  forState:(UIControlStateNormal)];
    }
}


- (void)collectionViewRefreshWith:(BOOL)isClick {
    if (isClick) {
        [_morebt setImage:[UIImage imageNamed:@"comment_arrow_down@2x"]  forState:(UIControlStateNormal)];
    } else {
        [_morebt setImage:[UIImage imageNamed:@"channel_nav_arrow@2x"] forState:(UIControlStateNormal)];
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        self.dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, 0) collectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.myView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myView);
        make.right.equalTo(self.myView);
        make.top.equalTo(self.myView);
        make.bottom.equalTo(self.myView);
        
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCThreeItem" bundle:nil] forCellWithReuseIdentifier:@"CCThreeItem"];
}






#pragma collectionView代理方法


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GZuWeiModel *model = self.dataSource[indexPath.row];
    CCThreeItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCThreeItem" forIndexPath:indexPath];
    [item.picimagev sd_setImageWithURL:[NSURL URLWithString:model.UserPic] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
    item.namelabel.text = model.CustomerName;
    return item;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return  CGSizeMake((Width_Screen - 90) / 5, (Width_Screen - 90) / 5);
  
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
