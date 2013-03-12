//
//  UIImageView+SDWebCache.m
//  SDWebData
//
//  Created by stm on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SDImageView+SDWebCache.h"
#import "CustomObject.h"
@implementation UIImageView(SDWebCacheCategory)

- (void)setImageWithURL:(NSURL *)url
{
	[self setImageWithURL:url refreshCache:NO];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache
{
	[self setImageWithURL:url refreshCache:refreshCache placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url refreshCache:(BOOL)refreshCache placeholderImage:(UIImage *)placeholder
{
	
    // Remove in progress downloader from queue
	
    self.image = placeholder;
	NSLog(@"%@",url);
    if (url)
    {
        if ([[CustomObject sharedCustomObject] isExistImage:url]) {
            //NSLog(@"存在图片");
            self.image = [[CustomObject sharedCustomObject]getImage:url];
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc]initWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[CustomObject sharedCustomObject] addImage:image key:url];
                        self.image = image;
                    });
                }
            });
        }
    }
}

@end
