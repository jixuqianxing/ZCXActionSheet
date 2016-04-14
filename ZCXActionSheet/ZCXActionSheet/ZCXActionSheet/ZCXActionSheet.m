//
//  ZCXActionSheet.m
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import "ZCXActionSheet.h"
#import "ZCXActionSheetContentView.h"

@interface ZCXActionSheet ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) ZCXActionSheetContentView * contentView;

@end

@implementation ZCXActionSheet

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                     showImagePicker:(BOOL)show
                              result:(ResultBlock)result
{
    return [[ZCXActionSheet alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles showImagePicker:show result:result];
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
              showImagePicker:(BOOL)show
                       result:(ResultBlock)result
{
    self = [super init];
    if (self) {
        
        [self setup];
        [self addTapGestureRecognizer];
        [self addNotification];
        
        _contentView = [ZCXActionSheetContentView contentViewWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles showImagePicker:show];
        
        [self addSubview:_contentView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_contentView);
        NSString *widthVfl  = @"H:|-0-[_contentView]-0-|";
        NSString *heightVfl = [NSString stringWithFormat:@"V:[_contentView]-0-|"];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
        
        _contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.frame));
        
        __weak typeof(self) weakSelf = self;
        _contentView.buttonClickBlock = ^(NSInteger index, NSArray *imageArray){
            [weakSelf dismiss:nil];
            result(index,imageArray);
        };
    }
    return self;
}

- (void)setSelectDescription:(NSString *)selectDescription {
    _selectDescription = selectDescription;
    _contentView.selectedDes = selectDescription;
}

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    _contentView.maxCount = maxCount;
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^
    {
        _contentView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss:(id)sender {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [UIView animateWithDuration:0.25
                              delay:0
             usingSpringWithDamping:0.8f
              initialSpringVelocity:0
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^
         {
             _contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(_contentView.frame));
             self.backgroundColor = [UIColor clearColor];
         } completion:^(BOOL finished) {
             [self removeFromSuperview];
         }];
    }else {
        [UIView animateWithDuration:0.1 animations:^{
            _contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(_contentView.frame));
            self.backgroundColor = [UIColor clearColor];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)addNotification {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    self.frame = [[UIScreen mainScreen] bounds];
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.frame = [[UIScreen mainScreen] bounds];
}

- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if(!CGRectContainsPoint(self.frame, [tap locationInView:_contentView])) {
        [self dismiss:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
//    NSLog(@"释放ZCXActionSheet");
    _contentView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

@end
