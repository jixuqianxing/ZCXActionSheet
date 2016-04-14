//
//  ZCXActionSheetContentView.m
//  ImagePickerActionSheet
//
//  Created by zcx on 15/7/7.
//  Copyright (c) 2015年 ZhengCaixi. All rights reserved.
//

#import "ZCXActionSheetContentView.h"
#import "ZCXCollectionReusableView.h"
#import "ZCXPhotoCollectionView.h"
#import "ZCXPhotoCell.h"
#import "ZCXPhotoManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

/**
 *  展示照片的collectionView的高度
 */
static CGFloat collectionViewHeight = 190.0f;
/**
 *  按钮高度
 */
static CGFloat buttonHeight = 50.0f;
/**
 *  标题高度
 */
static CGFloat titleHeight  = 40.0f;

static NSString * const cellReuseIdentifier = @"PhotoCell";
static NSString * const headerReuseIdentifier = @"ReusableView";

@interface ZCXActionSheetContentView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  标题Label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  展示图片的collectionView
 */
@property (nonatomic, strong) ZCXPhotoCollectionView * collectionView;

/**
 *  图片数组，里面装的是ALAsset对象
 */
@property (nonatomic, strong) NSMutableArray * imageArray;

/**
 *  选中的照片，里面装的是ALAsset对象
 */
@property (nonatomic, strong) NSMutableArray * selectedImageArray;

/**
 *  缓存ZCXCollectionReusableView
 */
@property (nonatomic, strong) NSMutableDictionary * headerDictionary;

/**
 *  存放按钮
 */
@property (nonatomic, strong) NSMutableArray * buttonArray;

/**
 *  是否显示图片选择
 */
@property (nonatomic, assign) BOOL showImagePicker;

@property (nonatomic, copy) NSString * firstBtnTitle;

@end

@implementation ZCXActionSheetContentView

+ (instancetype)contentViewWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                     showImagePicker:(BOOL)show {
    return [[ZCXActionSheetContentView alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles showImagePicker:show];
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
              showImagePicker:(BOOL)show {
    self = [super init];
    if (self) {
        
        [self setup];
        
        _title = title;
        _showImagePicker = show;
        
        if (show) [self loadPhotoData];
        
        NSMutableArray *titles = [[NSMutableArray alloc] initWithArray:otherButtonTitles];
        [titles addObject:cancelButtonTitle];
        [self createButtonsByTitlesArray:titles];
        
        [self layoutUI];
    }
    return self;
}

/**
 *  加载图片
 */
- (void)loadPhotoData {
    __weak typeof(self) weakSelf = self;
    [[ZCXPhotoManager sharedManager] getImages:^(NSMutableArray *imageArray) {
        weakSelf.imageArray = imageArray;
        [weakSelf.collectionView reloadData];
    }];
}

/**
 *  初始配置
 */
- (void)setup {
    self.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:226.0f/255.f blue:236.0f/255.0f alpha:1];
    self.bounds = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 0);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _selectedDes = @"发送";
    _maxCount = 9;
}

/**
 *  布局
 */
- (void)layoutUI {
    
    [self reset];
    
    __block CGFloat topMargin = 0.0f;
    
    /**
     *  标题
     */
    if (_title.length > 0) {
        [self addSubview:self.titleLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel);
        NSString *widthVfl  = @"H:|-0-[_titleLabel]-0-|";
        NSString *heightVfl = [NSString stringWithFormat:@"V:|-0-[_titleLabel(%f)]",titleHeight];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
        
        self.titleLabel.text = _title;
        topMargin = titleHeight;
    }
    
    /**
     *  照片选择器
     */
    if (_showImagePicker) {
        [self addSubview:self.collectionView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
        NSString *widthVfl  = @"H:|-0-[_collectionView]-0-|";
        NSString *heightVfl = [NSString stringWithFormat:@"V:|-%f-[_collectionView(%f)]",topMargin,collectionViewHeight];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
        topMargin += collectionViewHeight;
    }
    
    /**
     *  按钮
     */
    __block CGFloat buttonMargin = 1.0f;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [self addSubview:button];
        NSDictionary *views = NSDictionaryOfVariableBindings(button);
        NSString *widthVfl  = @"H:|-0-[button]-0-|";
        NSString *heightVfl = [NSString stringWithFormat:@"V:|-%f-[button(%f)]",topMargin,buttonHeight];
        if (idx == self.buttonArray.count - 1) heightVfl = [NSString stringWithFormat:@"V:|-%f-[button(%f)]-0-|",topMargin,buttonHeight];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
        
        if (idx == self.buttonArray.count - 2) {
            buttonMargin = 5.0f;
        }else
            buttonMargin = 1.0f;
        topMargin += buttonHeight + buttonMargin;
    }];
}

/**
 *  创建按钮
 *
 *  @param titleArray 按钮标题数组
 */
- (void)createButtonsByTitlesArray:(NSMutableArray *)titleArray {
    if (self.buttonArray.count > 0) {
        [self.buttonArray removeAllObjects];
    }
    [titleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            _firstBtnTitle = title;
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.tag = idx;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:btn];
    }];
}

/**
 *  用来展示标题的UILabel，懒加载
 *
 *  @return UILabel
 */
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

/**
 *  用来展示图片的collectionView，懒加载
 *
 *  @return collectionView
 */
- (ZCXPhotoCollectionView *)collectionView {
    if (_collectionView == nil) {
        ZCXPhotoCollectionView * collectionView = [ZCXPhotoCollectionView collectionViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), collectionViewHeight)];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[ZCXPhotoCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        [collectionView registerClass:[ZCXCollectionReusableView class] forSupplementaryViewOfKind:@"elementKind" withReuseIdentifier:headerReuseIdentifier];
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - DataArray
/**
 *  用来装选中图片的数组，懒加载的方式
 *
 *  @return 可变图片数组
 */
- (NSMutableArray *)selectedImageArray {
    if (_selectedImageArray == nil) {
        _selectedImageArray = [[NSMutableArray alloc] init];
    }
    return _selectedImageArray;
}

/**
 *  用来装图片的数组，懒加载的方式
 *
 *  @return 可变图片数组
 */
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

/**
 *  用来装按钮的数组，懒加载的方式
 *
 *  @return 可变按钮数组
 */
- (NSMutableArray *)buttonArray {
    if (_buttonArray == nil) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

- (NSMutableDictionary *)headerDictionary {
    if (_headerDictionary == nil) {
        _headerDictionary = [[NSMutableDictionary alloc] init];
    }
    return _headerDictionary;
}

/**
 *  移除子视图，防止重复添加
 */
- (void)reset {
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]] || [obj isKindOfClass:[ZCXPhotoCollectionView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

/**
 *  按钮点击事件
 *
 *  @param btn 被点击的按钮
 */
- (void)btnAction:(UIButton *)btn {
    if (btn.tag == self.buttonArray.count - 1) {
        [self.selectedImageArray removeAllObjects];
    }
    if (_buttonClickBlock) {
        _buttonClickBlock(btn.tag,self.selectedImageArray);
    }
}

#pragma mark - CollectionView datasouce

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCXPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    ALAsset *asset = self.imageArray[indexPath.row];
    
    UIImage *image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    
    cell.imageView.image = image;

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ZCXCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
    
    [self.headerDictionary setObject:reusableView forKey:indexPath];
    
    if ([[collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
        [reusableView setSelected:YES];
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectionAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectionAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ALAsset *asset = [self.imageArray objectAtIndex:indexPath.row];
    
    UIImage *imageAtPath = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    
    CGFloat imageHeight = imageAtPath.size.height;
    CGFloat viewHeight  = collectionView.bounds.size.height - 10;
    CGFloat scaleFactor = viewHeight/imageHeight;
    
    CGSize scaledSize = CGSizeApplyAffineTransform(imageAtPath.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
    return scaledSize;
}

#pragma mark - Private
/**
 *  处理选中与取消选中
 *
 *  @param indexPath 操作的cell所在的NSIndexPath
 */
- (void)selectionAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCXPhotoCell *cell = (ZCXPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    UIButton *btn = self.buttonArray[0];
    
    ZCXCollectionReusableView *reusableView = [self.headerDictionary objectForKey:indexPath];
    
    ALAsset *asset = self.imageArray[indexPath.row];

    if ([self.selectedImageArray containsObject:asset]) {
        [self.selectedImageArray removeObject:asset];
        [cell setSelected:NO];
        [reusableView setSelected:NO];
    } else {
        [self.selectedImageArray addObject:asset];
        [cell setSelected:YES];
        [reusableView setSelected:YES];
    }
    
    if (_maxCount < self.selectedImageArray.count) {
        [self showAlertView];
        [self.selectedImageArray removeObject:asset];
        [reusableView setSelected:NO];
        cell.selected = NO;
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (self.selectedImageArray.count == 0) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:_firstBtnTitle forState:UIControlStateNormal];
    }else{
        [btn setTitle:[NSString stringWithFormat:@"%@%ld张照片",_selectedDes,(unsigned long)self.selectedImageArray.count] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
}

/**
 *  提示选择照片超过限制
 */
- (void)showAlertView {
    [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您最多可选%@张",@(_maxCount)] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)setSelectedDes:(NSString *)selectedDes {
    _selectedDes = selectedDes;
}

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
}

- (void)dealloc {
    self.collectionView = nil;
    [self.buttonArray removeAllObjects];
    self.buttonArray = nil;
    [self.headerDictionary removeAllObjects];
    self.headerDictionary = nil;
    //    NSLog(@"释放ZCXActionSheetContentView");
}

@end
