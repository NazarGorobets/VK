//
//  NGLinkWallObjectData.h
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGLinkWallObjectData : NSObject
@property (strong, nonatomic) NSString* urlString;
@property (strong, nonatomic) NSString* title;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
