//
//  NGGetCommunitiesObjectData.h
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGGetCommunitiesObjectData : NSObject

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSURL*    imageURL;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;


@end
