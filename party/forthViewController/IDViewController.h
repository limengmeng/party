//
//  IDViewController.h
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import <UIKit/UIKit.h>

@interface IDViewController : UIViewController<UITextFieldDelegate>{
    UITextField *name;
    UITextField *password;
    UIButton *passWordButton;
    UITextField *phone;
    
    UIButton *button;//退出按钮
    
    NSString *mail;
    NSString *mail_pass;
}

@property (nonatomic,retain) NSString *mail;
@property (nonatomic,retain) NSString *mail_pass;

@end
