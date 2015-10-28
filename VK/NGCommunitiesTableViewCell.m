//
//  NGCommunitiesTableViewCell.m
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGCommunitiesTableViewCell.h"

@implementation NGCommunitiesTableViewCell

- (void)awakeFromNib {
    self.avatarCommunities.layer.cornerRadius = CGRectGetHeight(self.avatarCommunities.bounds)/2;
    self.avatarCommunities.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
