//
//  areaPicker.m
//  ceshiAreaPicker
//
//  Created by 李 萌萌 on 13-1-26.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "areaPicker.h"

@implementation areaPicker
@synthesize city,state;
@synthesize provinces;
@synthesize citys;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        provinces = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
        self.citys = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        self.state=[[provinces objectAtIndex:0]objectForKey:@"state"];
        self.city=[[[provinces objectAtIndex:0] objectForKey:@"cities"]objectAtIndex:0];
        NSLog(@"%@   %@",self.state,self.city);
        if (areapicker==nil) {
            areapicker = [[UIPickerView alloc] initWithFrame:self.bounds];
            areapicker.delegate = self;
            areapicker.dataSource=self;
            areapicker.showsSelectionIndicator = YES;
            [self addSubview:areapicker];
        }

        
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [provinces count];
    }
    else
    {
        return [citys count];
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [citys objectAtIndex:row];
            break;
        default:
            return @"";
            break;
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            citys = [[provinces objectAtIndex:row] objectForKey:@"cities"];
            [areapicker selectRow:0 inComponent:1 animated:YES];
            [areapicker reloadComponent:1];
            
            self.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
            self.city = [citys objectAtIndex:0];
            break;
        case 1:
            self.city = [citys objectAtIndex:row];
            break;
        default:
            break;
    }
    
    NSLog(@"%@,%@",self.state,self.city);
}

-(void)dealloc
{
    [areapicker release];
    [provinces release];
    [citys release];
    [state release];
    [city release];
    [super dealloc];
}
@end
