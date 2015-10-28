//
//  NGGetFriendsObjectData.m
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGGetFriendsObjectData.h"

@implementation NGGetFriendsObjectData


-(instancetype) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName  = [responseObject objectForKey:@"last_name"];
        self.userID    = [[responseObject objectForKey:@"id"] stringValue];
        
        self.status  =   [responseObject objectForKey:@"status"];
        self.cityID  = [[[responseObject objectForKey:@"city"] objectForKey:@"id"] integerValue];
        self.city    = [[responseObject objectForKey:@"city"]objectForKey:@"title"];
        
        int16_t online  = [[responseObject objectForKey:@"online"] integerValue];
        
        online == (1) ? (self.isOnline = @"Online") : (self.isOnline = @"offline");
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}


@end
