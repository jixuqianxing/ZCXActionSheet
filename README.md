# ZCXActionSheet



类似微信中的选择照片控件

![image](https://github.com/jixuqianxing/ZCXActionSheet/blob/master/Screenshot/demo.gif?raw=true)

![image](https://github.com/jixuqianxing/ZCXActionSheet/blob/master/Screenshot/demo.png?raw=true)

类似原生`UIActionSheet`接口设计，使用`AutoLayout`布局，支持横竖屏切换，按钮个数自定义，直接传入按钮标题即可。

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

# License

The MIT License (MIT)

Copyright (c) 2016 jixuqiangxing

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.