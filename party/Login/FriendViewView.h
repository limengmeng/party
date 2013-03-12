//
//  FriendViewView.h
//  party
//
//  Created by yilinlin on 13-2-3.
//
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@interface FriendViewView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *buttonCancel;
    UIButton *buttonAffirm;
    UITableView *tableViewFri;
    NSMutableArray *sumArray;
    NSString *userUUid;
    int selectRow;
}
@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) NSMutableArray *sumArray;
@property (nonatomic,retain) UITableView *tableViewFri;
@property (nonatomic,retain) UIButton *buttonCancel;
@property (nonatomic,retain) UIButton *buttonAffirm;
@end
