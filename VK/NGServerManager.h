//
//  NGServerManager.h
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VKSdk.h"
#import "NGAccessToken.h"
#import "NGGetUserObjectData.h"

@interface NGServerManager : NSObject

@property (strong, nonatomic) NGAccessToken* accessToken;

+ (NGServerManager *) sharedManager;


#pragma mark - GET USER INFO

- (void) getUsersInfoUserID:(NSString*) userId
                  onSuccess:(void(^)(NGGetUserObjectData* user)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


#pragma mark - GET USER PHOTOS


-(void) getPhotoUserID:(NSString*) userID
            withOffset:(NSInteger) offset
                 count:(NSInteger) count
             onSuccess:(void(^)(NSArray* photos)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


#pragma mark - UPLOAD PHOTO

- (void)  addAlbom: (NSString *) albom
       addFilePath: (NSString *) filePath
         onSuccess: (void(^) (NSDictionary *dict)) success
         onFailure: (void(^) (NSError *error)) failure;


#pragma mark - GET WALL

- (void)  getWall:(NSString*) ownerID
       withDomain:(NSString*) domain
       withFilter:(NSString*) filter
       withOffset:(NSInteger) offset
        typeOwner:(NSString*) typeOwner
            count:(NSInteger) count
        onSuccess:(void(^)(NSArray* posts)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


#pragma mark - GET FRIENDS

- (void) getFriendsWithOffset:(NSString*) userId
                   withOffset:(NSInteger) offset
                    withCount:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


#pragma mark - GET COMMUNITIES

- (void) getCommunitiesWithOffset:(NSString*) userId
                       withOffset:(NSInteger) offset
                        withCount:(NSInteger) count
                        onSuccess:(void(^)(NSArray* friends)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


@end
