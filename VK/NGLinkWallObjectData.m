//
//  NGLinkWallObjectData.m
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGLinkWallObjectData.h"

@implementation NGLinkWallObjectData

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        
        self.urlString = [[responseObject objectForKey:@"link"] objectForKey:@"url"];
        self.title     = [[responseObject objectForKey:@"link"] objectForKey:@"title"];
    }
    return self;
    
}

@end
