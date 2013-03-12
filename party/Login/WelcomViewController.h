//
//  WelcomViewController.h
//  scrol
//
//  Created by lly on 13-3-1.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomViewController : UIViewController<UIScrollViewDelegate>
{
   UIScrollView* scrollview;
    UIPageControl* pageController;
}
@end
