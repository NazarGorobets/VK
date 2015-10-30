//
//  NGMyFriendsTableViewCell.m
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGMyFriendsTableViewCell.h"

@implementation NGMyFriendsTableViewCell

- (void)awakeFromNib {
    self.avatarFriends.layer.cornerRadius = CGRectGetHeight(self.avatarFriends.bounds)/2;
    self.avatarFriends.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
