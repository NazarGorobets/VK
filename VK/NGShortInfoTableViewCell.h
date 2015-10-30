//
//  NGShortInfoTableViewCell.h
//  VK
//
//  Created by Naz on 10/28/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGShortInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (weak, nonatomic) IBOutlet UILabel *isOnlineUser;
@property (weak, nonatomic) IBOutlet UILabel *yearAndCityUser;

@end
