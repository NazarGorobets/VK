//
//  NGShortInfoTableViewCell.m
//  VK
//
//  Created by Naz on 10/28/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGShortInfoTableViewCell.h"

@implementation NGShortInfoTableViewCell

- (void)awakeFromNib {
    
    self.avatarUser.layer.cornerRadius  = CGRectGetHeight(self.avatarUser.bounds)/2;
    self.avatarUser.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
