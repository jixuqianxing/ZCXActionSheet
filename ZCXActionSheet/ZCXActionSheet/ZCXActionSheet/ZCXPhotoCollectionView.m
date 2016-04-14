//
//  ZCXPhotoCollectionView.m
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import "ZCXPhotoCollectionView.h"
#import "ZCXScrollLayout.h"

static CGFloat ImageSpacing = 5.0f;

@implementation ZCXPhotoCollectionView

+ (ZCXPhotoCollectionView *)collectionViewWithFrame:(CGRect)frame {
    return [[ZCXPhotoCollectionView alloc] collectionViewWithFrame:frame];
}

- (ZCXPhotoCollectionView *)collectionViewWithFrame:(CGRect)frame {
    
    ZCXScrollLayout *layout = [[ZCXScrollLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = ImageSpacing;
    layout.minimumLineSpacing = ImageSpacing;
    layout.sectionInset = UIEdgeInsetsMake(ImageSpacing, ImageSpacing, ImageSpacing, ImageSpacing);
    
    ZCXPhotoCollectionView *collectionView = [[ZCXPhotoCollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsSelection = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    
    return collectionView;
}

@end
