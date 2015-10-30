//
//  NGGetUserObjectData.m
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGGetUserObjectData.h"

@implementation NGGetUserObjectData

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName  = [responseObject objectForKey:@"last_name"];
        self.userID    = [[responseObject objectForKey:@"id"] stringValue];
        
        self.status    = [responseObject objectForKey:@"status"];
        
        
        self.bdate = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[responseObject objectForKey:@"date"]];
        self.lastSeen = [self parseDataWithDateFormetter:@"EEEE HH:mm" andDate:[[responseObject objectForKey:@"last_seen"] objectForKey:@"time"]];
        
        
        self.city    = [[responseObject objectForKey:@"city"]    objectForKey:@"title"];
        self.country = [[responseObject objectForKey:@"country"] objectForKey:@"title"];
        self.online  = [[responseObject objectForKey:@"online"] boolValue];
        
        
        NSString *urlString = [responseObject objectForKey:@"photo_max_orig"];
        if (urlString) {
            self.mainImageURL = [NSURL URLWithString:urlString];
        }
        
        self.photo_50URL  = [NSURL URLWithString:[responseObject objectForKey:@"photo_50"]];
        self.photo_100URL = [NSURL URLWithString:[responseObject objectForKey:@"photo_100"]];

        self.albums        = [[[responseObject objectForKey:@"counters"]  objectForKey:@"albums"] stringValue];
        self.audios        = [[[responseObject objectForKey:@"counters"]  objectForKey:@"audios"] stringValue];
        self.followers     = [[[responseObject objectForKey:@"counters"]  objectForKey:@"followers"] stringValue];
        self.friends       = [[[responseObject objectForKey:@"counters"]  objectForKey:@"friends"] stringValue];
        self.groups        = [[[responseObject objectForKey:@"counters"]  objectForKey:@"groups"] stringValue];
        self.pages         = [[[responseObject objectForKey:@"counters"]  objectForKey:@"pages"] stringValue];
        self.photos        = [[[responseObject objectForKey:@"counters"]  objectForKey:@"photos"] stringValue];
        self.videos        = [[[responseObject objectForKey:@"counters"]  objectForKey:@"videos"] stringValue];
        self.subscriptions = [[[responseObject objectForKey:@"counters"]  objectForKey:@"subscriptions"] stringValue];
        
        self.enableSendMessageButton = [[responseObject objectForKey:@"can_write_private_message"] boolValue];
        self.enableWritePostButton   = [[responseObject objectForKey:@"can_post"] boolValue];
        
        ino_t friendStatus   = [[responseObject objectForKey:@"friend_status"] integerValue];
        self.friendStatus  = friendStatus;
        
        
        
        if (friendStatus == 0) {
            self.enableAddFriendButton = YES;
            self.titleAddFriendButton  = @"Add to Friends";
        }
        else
            if (friendStatus == 1) {
                self.enableAddFriendButton = NO;
                self.titleAddFriendButton  = @"You send request";
            }
            else
                if (friendStatus == 2) {
                    self.enableAddFriendButton = YES;
                    self.titleAddFriendButton  = @"Add to Friends";
                }
                else
                    if (friendStatus == 3) {
                        self.enableAddFriendButton = NO;
                        self.titleAddFriendButton  = @"Remove friend";
                    }
    }
    
    return self;
    
}

-(NSString*) parseDataWithDateFormetter:(NSString*)dateFormat andDate:(NSString*) date {
    
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:dateFormat];
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    NSString *parseDate = [dateFormater stringFromDate:dateTime];
    
    return parseDate;
}



-(void) description {
    
    NSLog(@"\n");
    NSLog(@"First Name = %@",self.firstName);
    NSLog(@"Last Name  = %@",self.lastName);
    NSLog(@"bdate = %@",self.bdate);
    NSLog(@"country = %@",self.country);
    NSLog(@"city  = %@",self.city);
    NSLog(@"status = %@",self.status);
    NSLog(@"online = %d",self.online);
    NSLog(@"userID = %@",self.userID);
    NSLog(@"mainImage URL = %@",self.mainImageURL);
    
}

@end
