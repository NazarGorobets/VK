//
//  NGMyFriendsViewController.h
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGGetUserObjectData.h"
#import "NGGetCommunitiesObjectData.h"


@interface NGMyFriendsViewController : UITableViewController
@property (strong, nonatomic) NGGetUserObjectData*  currentUser;
@property (strong, nonatomic) NGGetCommunitiesObjectData* currentGroup;
@end
