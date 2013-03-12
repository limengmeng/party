//
//  areaPicker.h
//  ceshiAreaPicker
//
//  Created by 李 萌萌 on 13-1-26.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface areaPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView* areapicker;
    NSString* state;
    NSString* city;
    NSArray* provinces;
    NSArray* citys;  
}
@property (strong,nonatomic) NSString *state,* city;

@property (strong,nonatomic) NSArray* provinces;
@property (strong,nonatomic) NSArray* citys;

@end
