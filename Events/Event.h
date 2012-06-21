//
//  Event.h
//  Events
//
//  Created by Ryan Miller on 6/21/12.
//  Copyright (c) 2012 Thingworx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *startTime;
@property (nonatomic, copy) NSString *venueName;

@end
