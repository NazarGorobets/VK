//
//  NGGetCommunitiesObjectData.m
//  VK
//
//  Created by Naz on 10/21/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGGetCommunitiesObjectData.h"

@implementation NGGetCommunitiesObjectData


-(instancetype) initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.name    =   [responseObject objectForKey:@"name"];
        self.status  =   [responseObject objectForKey:@"type"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
}



@end
