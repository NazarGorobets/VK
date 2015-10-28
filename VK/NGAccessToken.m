//
//  NGAccessToken.m
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGAccessToken.h"

@implementation NGAccessToken

-(instancetype)init{
    self = [super init];
    if (self){
        
    }
    return self;
}
-(void)setToken:(NSString *)token{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    token = [defaults objectForKey:@"token"];
    [defaults synchronize];
}

-(NSString *)token{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

@end
