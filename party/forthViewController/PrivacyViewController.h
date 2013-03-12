//
//  PrivacyViewController.h
//  party
//
//  Created by mac bookpro on 1/20/13.
//
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : UIViewController<UITextFieldDelegate>{
    UITextField *field1;
    UITextField *field2;
    UITextField *field3;
    NSString *userUUid;
}
@property (nonatomic,retain) NSString *userUUid;

@end
