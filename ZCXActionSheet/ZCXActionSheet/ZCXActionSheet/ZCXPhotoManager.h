//
//  ZCXPhotoManager.h
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  展示的照片最大数量
 */
static NSInteger maxSize = 100;

/**
 *  单例，用于获取最新的100张图片
 */
@interface ZCXPhotoManager : NSObject

+ (ZCXPhotoManager *)sharedManager;

/**
 *  获取100张用户保存的照片
 *
 *  @param imageBlock 回调Block
 */
- (void)getImages:(void(^)(NSMutableArray *imageArray))imageBlock;

@end
