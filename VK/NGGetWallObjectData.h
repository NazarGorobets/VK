//
//  NGGetWallObjectData.h
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGGetUserObjectData.h"


@interface NGGetWallObjectData : NSObject

@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* postID;

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* date;


@property (strong, nonatomic) NSString* comments;
@property (strong, nonatomic) NSString* likes;
@property (strong, nonatomic) NSString* reposts;


@property (assign, nonatomic) BOOL canPost;
@property (assign, nonatomic) BOOL canLike;
@property (assign, nonatomic) BOOL canRepost;




@property (strong, nonatomic) NSString* fromID;
@property (strong, nonatomic) NSString* ownerID;


@property (strong, nonatomic) NSString* fullName;
@property (strong, nonatomic) NSURL*    urlPhoto;

@property (strong, nonatomic) NSMutableArray* attachments;


@property (strong, nonatomic) NGGetUserObjectData* user;

@property (assign, nonatomic) float imageViewSize;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
