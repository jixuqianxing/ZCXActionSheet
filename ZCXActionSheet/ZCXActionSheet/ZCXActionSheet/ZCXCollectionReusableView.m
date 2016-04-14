//
//  ZCXCollectionReusableView.m
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import "ZCXCollectionReusableView.h"

static NSString * const selectedIcon = @"ImageResources.bundle/photo_selected_yes.png";
static NSString * const deselectIcon = @"ImageResources.bundle/photo_selected_no.png";

@interface ZCXCollectionReusableView ()

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation ZCXCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSelected:NO];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setSelected:NO];
}

- (void)setSelected:(BOOL)selected {
    NSString *imageName = selected ? selectedIcon:deselectIcon;
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 20, 20)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.image = [UIImage imageNamed:deselectIcon];
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
