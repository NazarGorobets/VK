//
//  NGMusicWallObjectData.m
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGMusicWallObjectData.h"

@implementation NGMusicWallObjectData

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        
        
        NSDictionary* audioDict = [responseObject objectForKey:@"audio"];
        
        self.title = [audioDict objectForKey:@"title"];
        self.artist = [audioDict objectForKey:@"artist"];
        
        self.title = [audioDict objectForKey:@"title"];
        self.title = [audioDict objectForKey:@"title"];
        
        if ([audioDict objectForKey:@"url"]) {
            self.urlAudio = [NSURL URLWithString:[audioDict objectForKey:@"url"]];
        }
        
        self.ownerId = [[audioDict objectForKey:@"owner_id"] stringValue];
        
        self.duration = [self parseDataWithDateFormetter:@"mm:ss" andDate:[audioDict objectForKey:@"duration"]];
        self.date     = [self parseDataWithDateFormetter:@"dd MMM yyyy " andDate:[audioDict objectForKey:@"date"]];
        
        
        self.ID = [[audioDict objectForKey:@"id"] stringValue];
        
        
    }
    return self;
    
}



-(NSString*) parseDataWithDateFormetter:(NSString*)dateFormat andDate:(NSString*) date {
    
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:dateFormat];
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    NSString *parseDate = [dateFormater stringFromDate:dateTime];
    
    return parseDate;
}
@end
