//
//  ChangeMyInfoViewController.h
//  party
//
//  Created by 李 萌萌 on 13-1-27.
//
//

#import <UIKit/UIKit.h>
@protocol PassValueDelegate
-(void)passValue:(NSString*)value andChangeinfo:(int)changeinfo;
@end
@interface ChangeMyInfoViewController : UIViewController<UITextViewDelegate>
{
    UITextView* textview;
    NSString* beginstr;
    id<PassValueDelegate> delegate;
}
@property (strong,nonatomic)NSString* beginstr;
@property (assign,nonatomic) id<PassValueDelegate> delegate;
//代理只能引用

-(void)ChangeInfo;
@end
