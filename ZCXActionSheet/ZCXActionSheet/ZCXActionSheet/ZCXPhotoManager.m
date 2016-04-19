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
    __block NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            id type = [group valueForProperty:ALAssetsGroupPropertyType];
            if ([type integerValue] == 16)
            {
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result && assetsArray.count <= maxSize)
                    {
                        [assetsArray addObject:result];
                    }else{
                        *stop = YES;
                    }
                }];
                imageBlock(assetsArray);
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
        imageBlock(nil);
    }];
}

@end
