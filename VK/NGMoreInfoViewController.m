//
//  NGMoreInfoViewController.m
//  VK
//
//  Created by Naz on 10/22/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGMoreInfoViewController.h"
#import "NGGetUserObjectData.h"

@interface NGMoreInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (weak, nonatomic) IBOutlet UILabel *isOnlineUser;
@property (weak, nonatomic) IBOutlet UILabel *yearAndCityUser;
@property (weak, nonatomic) IBOutlet UILabel *statusUserCell;

@end

@implementation NGMoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarUser.layer.cornerRadius  = CGRectGetHeight(self.avatarUser.bounds)/2;
    self.avatarUser.layer.masksToBounds = YES;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 2;
    }
    if (section == 3) {
        return 0;
    }
    
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1)
        return 10.0f;
    
    return 0;
}

@end
