//
//  NGWallCellTableViewCell.h
//  VK
//
//  Created by Naz on 10/27/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NGGetWallObjectData.h"

@interface NGWallCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ownerPhoto;

@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *textPost;


@property (weak, nonatomic) IBOutlet UIView *sharedView;


@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIView *repostView;
@property (weak, nonatomic) IBOutlet UILabel *repostLabel;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;

//@property (weak, nonatomic) IBOutlet UIButton *openOwnerPage;


+(CGFloat) heightForTextWithPostModel:(NGGetWallObjectData*) wall andWidthTextCell:(CGFloat) widthCellText;

@end
