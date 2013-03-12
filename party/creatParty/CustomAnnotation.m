//
//  CustomAnnotation.m
//  LocationMap
//
//  Created by Chendy on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomAnnotation.h"


@implementation CustomAnnotation
@synthesize coordinate = coordinate_;
@synthesize title = title_;
@synthesize subtitle = subtitle_;

-(void)dealloc
{
	[title_ release];
    [subtitle_ release];
	[super dealloc];
}
@end
