//
//  ZCXActionSheet.h
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  按钮点击完成事件
 *
 *  @param buttonIndex         点击的按钮位置
 *  @param selectedImagesArray 选择的照片数组，数组元素为 ALAsset 对象
 */
typedef void(^ResultBlock)(NSInteger buttonIndex, NSArray *selectedImagesArray);


@interface ZCXActionSheet : UIView

@property (nonatomic, copy) NSString *selectDescription;/**< 选中照片时，第一个按钮上面的文本显示内容，默认值“发送”*/

@property (assign, nonatomic) NSInteger maxCount;/**< 最多选择张数*/

/**
 *  类方法来构造一个 ZCXActionSheet
 *
 *  @param title             标题
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题数组
 *  @param show              是否显示图片选择器
 *  @param result            回调 Block
 *
 *  @return 返回一个ZCXActionSheet
 */
+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                     showImagePicker:(BOOL)show
                              result:(ResultBlock)result;

/**
 *  显示到界面
 */
- (void)show;

@end
