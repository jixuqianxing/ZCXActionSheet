//
//  ZCXCollectionReusableView.h
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCXCollectionReusableView : UICollectionReusableView

/**
 *  设置是否选中
 *
 *  @param selected YES：选中；NO：取消选中
 */
- (void)setSelected:(BOOL)selected;

@end
