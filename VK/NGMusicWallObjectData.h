//
//  NGMusicWallObjectData.h
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGMusicWallObjectData : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* artist;

@property (strong, nonatomic) NSURL* urlAudio;

@property (strong, nonatomic) NSString* ownerId;
@property (strong, nonatomic) NSString* date;

@property (strong, nonatomic) NSString* duration;

@property (strong, nonatomic) NSString* ID;



-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
