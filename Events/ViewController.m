//
//  ViewController.m
//  Events
//
//  Created by Ryan Miller on 6/21/12.
//  Copyright (c) 2012 Thingworx. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize xmlParser = _xmlParser;
@synthesize currentEvent = _currentEvent;
@synthesize currentString = _currentString;
@synthesize storeCharacters = _storeCharacters;
@synthesize url = _url;
@synthesize eventsArray = _eventsArray;
@synthesize dateFormatter = _dateFormatter;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    static NSString *APPKEY = @"app_key=ZRtCkJK7gBg9LCMf&";
    static NSString *LOCATION = @"location=19468&";
    static NSString *CATEGORY = @"category=music&";
    static NSString *DATE = @"date=future&";
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://api.eventful.com/rest/events/search?"];
    [url appendString:APPKEY];
    [url appendString:LOCATION];
    [url appendString:CATEGORY];
    [url appendString:DATE];
    
    NSLog(@"URL created: %@", url);
    
    self.xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    self.xmlParser.delegate = self;
    
    self.eventsArray = [NSMutableArray array];
    self.currentString = [NSMutableString string];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [NSLocale currentLocale];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    if ([self.xmlParser parse])
        NSLog(@"XML Parsed");
    else 
        NSLog(@"Failed to parse");
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

# pragma mark - Table view data source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EventTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    Event *event = [self.eventsArray objectAtIndex:indexPath.row];
    NSLog(@"%@", event);
    
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = event.venueName;
    
    return cell;
}

# pragma mark - Helpers
- (BOOL) notEvent:(NSString *)elementName {
    return ([elementName isEqualToString:kName_Title] || 
            [elementName isEqualToString:kName_StartTime] || 
            [elementName isEqualToString:kName_Event] || 
            [elementName isEqualToString:kName_VenueName]); 
}

- (BOOL) isEvent:(NSString *)elementName {
    return ([elementName isEqualToString:@"event"]);
}

#pragma  mark -
#pragma mark Parser Delegate

static NSString *kName_Event = @"event";
static NSString *kName_Title = @"title";
static NSString *kName_StartTime = @"start_time";
static NSString *kName_VenueName = @"venue_name";

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // handler errors
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"%d", self.eventsArray.count);
    [self.tableView reloadData];
}

- (void) finishedCurrentEvent:(Event *)e {
    [self.eventsArray addObject:e];
    self.currentEvent = nil;
}   

- (void) parser:(NSXMLParser *)parser 
  didEndElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kName_Title]) {
        self.currentEvent.title = _currentString;
    } else if ([elementName isEqualToString:kName_VenueName]) {
        self.currentEvent.venueName = _currentString;
    } else if ([elementName isEqualToString:kName_StartTime]) {
        self.currentEvent.startTime = [self.dateFormatter dateFromString: _currentString];
    } if ([elementName isEqualToString:kName_Event]) {
        [self finishedCurrentEvent:_currentEvent];
    }
    
    self.storeCharacters = NO;
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.storeCharacters) {
        [self.currentString appendString:string];
    }
}

- (void) parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName 
     attributes:(NSDictionary *)attributeDict {
    
    if ( [self isEvent:elementName] ) {
        self.currentEvent = [[Event alloc] init];
        self.storeCharacters = NO;
    } else if ( [self notEvent:elementName] ){
        [self.currentString setString:@""];
        self.storeCharacters = YES;
    }
}

@end