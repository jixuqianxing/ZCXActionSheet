//
//  ZCXActionSheetContentView.h
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCXActionSheetContentView : UIView

@property (copy, nonatomic) NSString *selectedDes;/**< 选中照片时显示的文字*/

@property (nonatomic, assign) NSInteger maxCount;/**< 最大选择张数*/

/**
 *  按钮事件
 */
@property (nonatomic, copy) void(^buttonClickBlock)(NSInteger index, NSArray *selectedALAssetArray);

+ (instancetype)contentViewWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                     showImagePicker:(BOOL)show;

@end
