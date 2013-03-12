//
//  sexPicker.h
//  picher
//
//  Created by 李 萌萌 on 13-1-26.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sexPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView* sexpicker;
    NSString* sex;
    NSArray* sexlist;
}

@property (strong,nonatomic) NSString* sex;

@end
