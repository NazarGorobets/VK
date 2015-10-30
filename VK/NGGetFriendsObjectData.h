//
//  NGGetFriendsObjectData.h
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGGetFriendsObjectData : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;

@property (strong, nonatomic) NSString* status;
@property (assign, nonatomic) long long int cityID;
@property (strong, nonatomic) NSString* city;

@property (strong, nonatomic) NSString* isOnline;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSURL*    imageURL;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;


@end
