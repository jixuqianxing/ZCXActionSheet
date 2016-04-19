# ZCXActionSheet

------

类似微信中的选择照片控件

![image](https://github.com/jixuqianxing/ZCXActionSheet/blob/master/Screenshot/demo.gif?raw=true)

用法：

```ruby
ZCXActionSheet *sheet = [ZCXActionSheet actionSheetWithTitle:nil
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@[@"拍照",
                                                                   @"从手机相册选择",
                                                                   @"按钮1",
                                                                   @"按钮2"]
                                                 showImagePicker:YES
                                                          result:^(NSInteger buttonIndex, NSArray *selectedImagesArray)
                             {
                                 NSLog(@"selectedIndex： %@\nselectedImages： %@",@(buttonIndex),selectedImagesArray);
                             }];
sheet.selectDescription = @"确认选择";
sheet.maxCount = 9;
[sheet show];
```