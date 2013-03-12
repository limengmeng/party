//
//  MyAnnotation.m
//  Aibangapi
//
//  Created by lly on 13-2-3.
//  Copyright (c) 2013年 尹林林. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate, title, subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coords
{
    if (self = [super init]) {
        coordinate = coords;
    }
    return self;
}

-(void)dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end
