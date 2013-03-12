//
//  passwordViewController.h
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import <UIKit/UIKit.h>

@interface passwordViewController : UIViewController<UITextFieldDelegate>{
    UITextField *oldPass;
    UITextField *newPass;
    UITextField *passAgan;
    
    NSString *mail;
    NSString *mail_pass;
    
    NSString *mynewPass;
    NSString *mynewPassDone;
    
    NSString *userUUid;
}

@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) NSString *mail;
@property (nonatomic,retain) NSString *mail_pass;

@property (nonatomic,retain) NSString *mynewPass;
@property (nonatomic,retain) NSString *mynewPassDone;

@end
