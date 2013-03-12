//
//  takePhoto.h
//  resign
//
//  Created by mac bookpro on 1/27/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface takePhoto : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UILabel *labelName;//上传照片
    UIImageView *imgView;//图片
    UIButton *button1;
    UIButton *button2;
    UIImage *photoImg;
}

@property (nonatomic,retain) UILabel *labelName;//上传照片
@property (nonatomic,retain) UIImageView *imgView;//图片
@property (nonatomic,retain) UIButton *button1;
@property (nonatomic,retain) UIButton *button2;
@property (nonatomic,retain) UIImage *photoImg;
@end
