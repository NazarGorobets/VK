//
//  NGGetUserObjectData.h
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGGetUserObjectData : NSObject


@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;

@property (strong, nonatomic) NSString* bdate;
@property (strong, nonatomic) NSString* lastSeen;

@property (strong, nonatomic) NSString* countryID;
@property (strong, nonatomic) NSString* cityID;

@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* city;

@property (strong, nonatomic) NSString* status;
@property (assign, nonatomic) BOOL online;

@property (strong, nonatomic) NSString* userID;

@property (strong, nonatomic) NSString* mainImageURL;
@property (strong, nonatomic) NSURL* photo_50URL;
@property (strong, nonatomic) NSURL* photo_100URL;

@property (assign, nonatomic) int  friendStatus;

@property (assign, nonatomic) BOOL enableSendMessageButton;
@property (assign, nonatomic) BOOL enableWritePostButton;
@property (assign, nonatomic) BOOL enableAddFriendButton;

@property (strong, nonatomic) NSString* titleAddFriendButton;

@property (strong, nonatomic) NSString* albums;
@property (strong, nonatomic) NSString* audios;
@property (strong, nonatomic) NSString* followers;
@property (strong, nonatomic) NSString* friends;
@property (strong, nonatomic) NSString* groups;
@property (strong, nonatomic) NSString* pages;
@property (strong, nonatomic) NSString* photos;
@property (strong, nonatomic) NSString* videos;
@property (strong, nonatomic) NSString* subscriptions;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

-(void) description;

@end
