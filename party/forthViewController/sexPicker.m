//
//  sexPicker.m
//  picher
//
//  Created by 李 萌萌 on 13-1-26.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "sexPicker.h"

@implementation sexPicker
@synthesize sex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        sexlist=[[NSArray alloc]initWithObjects:@"男",@"女", nil];
        sex=[sexlist objectAtIndex:0];
        if (sexpicker==nil) {
            sexpicker = [[UIPickerView alloc] initWithFrame:self.bounds];
            sexpicker.delegate = self;
            sexpicker.dataSource=self;
            sexpicker.showsSelectionIndicator = YES;
            [self addSubview:sexpicker];
        }

    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [sexlist objectAtIndex:row];
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.sex=[sexlist objectAtIndex:row];
    NSLog(@"%@",self.sex);
}

-(void)dealloc
{
    [sexlist release];
    [sexpicker release];
    [sex release];
    [super dealloc];
}
@end
