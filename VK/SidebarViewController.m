//
//  SidebarViewController.m
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NGGetUserObjectData.h"


@interface SidebarViewController ()

@property (weak, nonatomic) NSURL *userLinkImg;

@end


@implementation SidebarViewController {

    NSArray *menuItems;
    __weak IBOutlet UIImageView *imageUser;
    __weak IBOutlet UILabel *nameUser;
}
@synthesize imageUser;
@synthesize nameUser;
@dynamic tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    menuItems = @[@"Friends",@"Communities", @"Photos", @"User"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setInformationOfMenu];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

-(void) setInformationOfMenu {
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
////    NSURL *image = [userDefaults objectForKey:@"image"];
//    self.nameUser.text = [userDefaults objectForKey:@"firstName"];
//
//        [self.imageUser setImageWithURL:self.imageUs placeholderImage:[UIImage imageNamed:@"user202"]];
//        
// 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
// Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
 }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}

@end
