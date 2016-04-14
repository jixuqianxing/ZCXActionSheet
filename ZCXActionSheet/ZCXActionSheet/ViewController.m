//
//  ViewController.m
//  ZCXActionSheet
//
//  Created by zcx on 16/4/14.
//  Copyright © 2016年 继续前行. All rights reserved.
//

#import "ViewController.h"
#import "ZCXActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showSheet:(id)sender {
    ZCXActionSheet *sheet = [ZCXActionSheet actionSheetWithTitle:nil
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@[@"拍照",
                                                                   @"从手机相册选择"]
                                                 showImagePicker:YES
                                                          result:^(NSInteger buttonIndex, NSArray *selectedImagesArray)
                             {
                                 NSLog(@"selectedIndex： %@\nselectedImages： %@",@(buttonIndex),selectedImagesArray);
                             }];
    sheet.selectDescription = @"确认选择";
    sheet.maxCount = 9;
    [sheet show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
