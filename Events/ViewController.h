//
//  ViewController.h
//  Events
//
//  Created by Ryan Miller on 6/21/12.
//  Copyright (c) 2012 Thingworx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface ViewController : UITableViewController <NSXMLParserDelegate>

    @property (nonatomic, strong) NSXMLParser *xmlParser;
    @property (nonatomic, strong) Event *currentEvent;
    @property (nonatomic, strong) NSMutableString *currentString;
    @property (nonatomic, assign) BOOL storeCharacters;
    @property (nonatomic, strong) NSString *url;
    @property (nonatomic, strong) NSDateFormatter *dateFormatter;
    @property (nonatomic, strong) NSMutableArray *eventsArray;

    - (BOOL) isEvent:(NSString *)elementName;
    - (BOOL) notEvent:(NSString *)elementName;
    - (void) finishedCurrentEvent:(Event *)e;

@end
