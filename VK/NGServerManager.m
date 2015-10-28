//
//  NGServerManager.m
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGServerManager.h"

#import "AFNetworking.h"

//   OBJECT DATA
#import "NGAccessToken.h"
#import "NGGetFriendsObjectData.h"
#import "NGGetWallObjectData.h"
#import "NGGetUserObjectData.h"
#import "NGGetPhotosObjectData.h"
#import "NGGetCommunitiesObjectData.h"
#import "NGPhotoObjectData.h"
#import "NGMusicObjectData.h"





@interface NGServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (strong,nonatomic) dispatch_queue_t requestQueue;

@end

@implementation NGServerManager

+ (NGServerManager *) sharedManager {
    
    static NGServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NGServerManager alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.accessToken = [[NGAccessToken alloc] init];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    return self;
}



#pragma mark - GET USER INFO

- (void) getUsersInfoUserID:(NSString*) userId
                  onSuccess:(void(^)(NGGetUserObjectData* user)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,      @"user_ids",
                            @"sex,"
                            "bdate,"
                            "city,"
                            "country,"
                            "photo_max_orig,"
                            "online,"
                            "photo_id,"
                            "can_post,"
                            "can_write_private_message,"
                            "status,"
                            "last_seen,"
                            "counters,"
                            "friend_status,"
                            "personal",  @"fields",
                            @"nom",      @"name_case",
                            @"5.37",     @"v",
                            self.accessToken.token, @"access_token",nil];
    
    [self.requestOperationManager GET:@"https://api.vk.com/method/users.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                                                
                                  NSArray* responceArray = [responseObject objectForKey:@"response"];
                                  NGGetUserObjectData* user = nil;
                                  
                                  for (NSDictionary* dict in responceArray) {
                                      user = [[NGGetUserObjectData alloc] initWithServerResponse:dict];
                                  }
                                  
                                  
                                  if (success) {
                                      success(user);
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}







#pragma mark - GET USER PHOTOS


-(void) getPhotoUserID:(NSString*) userID
            withOffset:(NSInteger) offset
                 count:(NSInteger) count
             onSuccess:(void(^)(NSArray* photos)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID,      @"owner_id",
                            @"wall",     @"album_id",
                            //@"",         @"photo_ids",
                            @"1",        @"rev",
                            @"1",        @"extended",
                            // @"photo",    @"feed_type",
                            //@"0",        @"photo_sizes",
                            @(offset),   @"offset",
                            @(count),    @"count",
                            @"5.37",     @"v",
                            self.accessToken.token, @"access_token",nil];
    
    [self.requestOperationManager GET:@"https://api.vk.com/method/photos.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  NSArray*  items    = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                                  
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary* dict in items) {
                                      
                                      NGPhotoObjectData* photo = [[NGPhotoObjectData alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:photo];
                                  }
                                  
                                  
                                  if (success) {
                                      success(objectsArray);
                                  }
                              }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
    
}



#pragma mark - UPLOAD PHOTO

- (void)  addAlbom: (NSString *) albom
       addFilePath: (NSString *) filePath
         onSuccess: (void(^) (NSDictionary *dict)) success
         onFailure: (void(^) (NSError *error)) failure {
    
    
    NSDictionary *requestParametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      albom,  @"owner_id",
                                      filePath,@"count", nil];
    
    VKRequest * request = [VKApi uploadWallPhotoRequest:[UIImage imageNamed:@"circle_add_plus-512"]
                                             parameters:[VKImageParameters pngImage]
                                                 userId:0
                                                groupId:-102872314];
    
    VKRequest * post = [VKApi requestWithMethod:@"https://api.vk.com/method/wall.post"
                                  andParameters:requestParametrs
                                  andHttpMethod:@"GET"];
    
    VKBatchRequest * batch = [[VKBatchRequest alloc] initWithRequests:request, post, nil];
    
    [batch executeWithResultBlock:^(NSArray *responses) {
        
        NSLog(@"Responses: %@", responses);
    }
                       errorBlock:^(NSError *error) {
                           NSLog(@"Error: %@", error);
                           
                       }];
    
}



#pragma mark - GET WALL

- (void)  getWall:(NSString*) ownerID
       withDomain:(NSString*) domain
       withFilter:(NSString*) filter
       withOffset:(NSInteger) offset
        typeOwner:(NSString*) typeOwner
            count:(NSInteger) count
        onSuccess:(void(^)(NSArray* posts)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    if ([typeOwner isEqualToString:@"group"]) {
        
        if (![ownerID hasPrefix:@"-"]) {
            ownerID = [@"-" stringByAppendingString:ownerID];
        }
        
    }
    
    NSMutableDictionary* params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     ownerID,       @"owner_id",
     @"",           @"domain",
     @(count),      @"count",
     @(offset),     @"offset",
     filter,        @"filter",
     @"1",          @"extended",
     @"5.37",       @"v",
     self.accessToken.token, @"access_token", nil];
    
    
    
    [self.requestOperationManager  GET:@"https://api.vk.com/method/wall.get"
                            parameters:params
                               success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                   
                                   
//                                   dispatch_async(self.requestQueue, ^{
                                   
                                       
                                       NSArray*   wallArray     = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                                       NSArray*   profilesArray = [[responseObject objectForKey:@"response"] objectForKey:@"profiles"];
                                       NSArray*   groupArray    = [[responseObject objectForKey:@"response"] objectForKey:@"groups"];
                                       
                                       NSMutableArray *arrayWithProfiles = [[NSMutableArray alloc]init];
                                       
                                       NSMutableDictionary* profilesBase = [NSMutableDictionary dictionary];
                                       NSMutableDictionary* groupsBase   = [NSMutableDictionary dictionary];
                                       
                                       if (wallArray) {
                                           
                                           
                                           for (NSDictionary* dict in profilesArray) {
                                               [profilesBase setValue:dict forKey:[[dict objectForKey:@"id"] stringValue]];
                                           }
                                           
                                           for (NSDictionary* dict in groupArray) {
                                               
                                               NSString* key = [[dict objectForKey:@"id"] stringValue];
                                               if (![key hasPrefix:@"-"]) {
                                                   key = [@"-" stringByAppendingString:key];
                                               }
                                               [groupsBase setValue:dict forKey:key];
                                           }
                                           
                                           
                                           
                                           for (int i=0; i<[wallArray count]; i++) {
                                               
                                               NSDictionary* dictItem    = wallArray[i];
                                               NGGetWallObjectData* wall = [[NGGetWallObjectData alloc] initWithServerResponse:dictItem];
                                               
                                               [arrayWithProfiles addObject:wall];
                                           }
                                           
                                       }
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           if (success) {
                                               success(arrayWithProfiles);
                                           }
                                       });
                                   //});
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"Error: %@", error);
                                   
                                   if (failure) {
                                       failure(error, operation.response.statusCode);
                                   }
                               }];
    
}


#pragma mark - GET FRIENDS

- (void) getFriendsWithOffset:(NSString*) userId
                   withOffset:(NSInteger) offset
                    withCount:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId, @"user_id",
                            //@"hints",     @"order",
                            @"hints",     @"order",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"photo_100,city,status",  @"fields",
                            @"nom",       @"name_case",
                            @"5.37",      @"v",
                            self.accessToken.token, @"access_token", nil];
    
    
    
    
    [self.requestOperationManager GET:@"https://api.vk.com/method/friends.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  
                                  NSArray* friendsArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  
                                  for (NSDictionary* dict in friendsArray) {
                                      
                                      NGGetFriendsObjectData *friend = [[NGGetFriendsObjectData alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:friend];
                                  }
                                  
                                  
                                  if (success) {
                                      success(objectsArray);
                                  }
                              }
     
     
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}


#pragma mark - GET COMMUNITIES

- (void) getCommunitiesWithOffset:(NSString*) userId
                       withOffset:(NSInteger) offset
                        withCount:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,       @"user_id",
                            @"1",         @"extended",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"5.37",      @"v",
                            self.accessToken.token, @"access_token", nil];
    
    
    
    
    [self.requestOperationManager GET:@"https://api.vk.com/method/groups.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  
                                  NSArray* friendsArray = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  
                                  for (NSDictionary* dict in friendsArray) {
                                      
                                      NGGetCommunitiesObjectData *friend = [[NGGetCommunitiesObjectData alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:friend];
                                  }
                                  
                                  
                                  if (success) {
                                      success(objectsArray);
                                  }
                              }
     
     
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}

@end
