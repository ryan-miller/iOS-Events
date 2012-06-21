//
//  Event.m
//  Events
//
//  Created by Ryan Miller on 6/21/12.
//  Copyright (c) 2012 Thingworx. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize title = _title;
@synthesize startTime = _starttime;
@synthesize venueName = _venueName;

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", _title, _venueName];
}

@end
