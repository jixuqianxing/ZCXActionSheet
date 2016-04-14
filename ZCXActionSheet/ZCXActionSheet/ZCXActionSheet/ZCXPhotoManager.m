//
//  ZCXPhotoManager.m
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import "ZCXPhotoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ZCXPhotoManager ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSArray *caheImagesArray;

@end

@implementation ZCXPhotoManager

+ (ZCXPhotoManager *)sharedManager {
    static ZCXPhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZCXPhotoManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void)getImages:(void(^)(NSMutableArray *imageArray))imageBlock {
    
    /**
     *  优先展示缓存数据
     */
    if (_caheImagesArray.count > 0) {
        imageBlock([_caheImagesArray mutableCopy]);
    }
    
    __block NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group) {
             ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
             [group setAssetsFilter:onlyPhotosFilter];
             [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                 if (result) {
                     [assetsArray addObject:result];
                     if (assetsArray.count == maxSize) {
                         *stop = YES;
                     }
                 }
             }];
         }else{
             imageBlock(assetsArray);
             _caheImagesArray = [assetsArray copy];
         }
     } failureBlock:^(NSError *error) {
         NSLog(@"Error loading images %@", error);
         imageBlock(nil);
     }];
}

@end
