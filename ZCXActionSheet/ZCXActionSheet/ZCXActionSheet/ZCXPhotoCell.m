//
//  ZCXPhotoCell.m
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import "ZCXPhotoCell.h"

@interface ZCXPhotoCell ()

@end

@implementation ZCXPhotoCell

- (void)prepareForReuse {
    [self setSelected:NO];
}

- (void)setBounds:(CGRect)bounds {
    self.contentView.frame = bounds;
    [super setBounds:bounds];
    
    self.imageView.frame = bounds;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = self.bounds;
        _imageView.userInteractionEnabled = NO;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end
