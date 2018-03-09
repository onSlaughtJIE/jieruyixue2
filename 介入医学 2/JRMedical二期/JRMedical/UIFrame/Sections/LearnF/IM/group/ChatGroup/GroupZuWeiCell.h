//
//  GroupZuWeiCell.h
//  JRMedical
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Expandable) (void);

@interface GroupZuWeiCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy ) Expandable isExpandable;
@property (nonatomic,assign) BOOL expand;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *myView;


@property (strong, nonatomic) IBOutlet UIButton *morebt;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) CGFloat height;


- (void)collectionViewRefreshWith:(BOOL)isClick;



@end
