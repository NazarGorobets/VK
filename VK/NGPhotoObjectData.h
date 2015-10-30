//
//  NGPhotoObjectData.h
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NGPhotoObjectData : NSObject

@property (strong, nonatomic) NSString* owner_id;
@property (strong, nonatomic) NSString* postID;
@property (strong, nonatomic) NSString* albumID;

@property (strong, nonatomic) NSString* date;


@property (strong, nonatomic) NSString* commentsCount;
@property (strong, nonatomic) NSString* likesCount;
@property (assign, nonatomic) BOOL      canComment;

@property (assign, nonatomic) int height;
@property (assign, nonatomic) int width;


@property (strong, nonatomic) NSURL* photo_75URL;
@property (strong, nonatomic) NSURL* photo_130URL;
@property (strong, nonatomic) NSURL* photo_604URL;
@property (strong, nonatomic) NSURL* photo_807URL;
@property (strong, nonatomic) NSURL* photo_1280URL;

@property (strong, nonatomic) UIImage* photo_75image;
@property (strong, nonatomic) UIImage* photo_130image;
@property (strong, nonatomic) UIImage* photo_604image;
@property (strong, nonatomic) UIImage* photo_807image;
@property (strong, nonatomic) UIImage* photo_1280image;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;
-(instancetype) initFromResponseWallGet:(NSDictionary*) responseObject;

-(void) description;
@end
