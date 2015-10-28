//
//  NGMyFriendsTableViewCell.h
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGMyFriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarFriends;
@property (weak, nonatomic) IBOutlet UILabel *nameFriend;

@property (weak, nonatomic) IBOutlet UIImageView *imageIsOnline;
@end
