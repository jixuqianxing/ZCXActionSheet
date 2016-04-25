//
//  ZCXCollectionViewLayout.m
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import "ZCXCollectionViewLayout.h"

static CGFloat HorizontalCheckmarkInset = 4.0;

@implementation ZCXCollectionViewLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // Add our supplementary views, thet checkmark views
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attrs, NSUInteger idx, BOOL *stop) {
        [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:@"elementKind" atIndexPath:attrs.indexPath]];
    }];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // Capture some commonly used variables...
    CGRect collectionViewBounds = self.collectionView.bounds;
    CGFloat collectionViewXOffset = self.collectionView.contentOffset.x;
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *checkAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    checkAttributes.size = CGSizeMake(28, 28);
    checkAttributes.zIndex = 100;
    
    CGFloat checkVerticalCenter = checkAttributes.size.height/2+3;
    
    checkAttributes.center = (CGPoint){
        CGRectGetMaxX(cellAttributes.frame) - HorizontalCheckmarkInset - checkAttributes.size.width/2,
        checkVerticalCenter
    };
    
    // If the left side of the check view isn't visible, but the relative cell view is, move the check to the left so it is also visible.
    CGFloat leftSideOfCell = CGRectGetMinX(cellAttributes.frame);
    CGFloat rightSideOfVisibleArea = collectionViewXOffset + CGRectGetWidth(collectionViewBounds);
    if (leftSideOfCell < rightSideOfVisibleArea && CGRectGetMaxX(checkAttributes.frame) >= rightSideOfVisibleArea) {
        checkAttributes.center = (CGPoint){
            rightSideOfVisibleArea - checkAttributes.size.width/2,
            checkVerticalCenter
        };
    }
    
    // Never let the left side of the check view be less than the left side of the cell plus padding.
    if (CGRectGetMinX(checkAttributes.frame) < leftSideOfCell + HorizontalCheckmarkInset) {
        checkAttributes.center = (CGPoint) {
            leftSideOfCell + HorizontalCheckmarkInset + checkAttributes.size.width/2,
            checkVerticalCenter
        };
    }
    
    return checkAttributes;
}

@end
