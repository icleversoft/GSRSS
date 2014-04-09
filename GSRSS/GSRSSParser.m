//
//  GSRSSParser.m
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSRSSParser.h"
#import "GSFeedInfo.h"
#import "GSFeedItem.h"

@interface GSRSSParser ()
    @property(nonatomic, strong) NSURL *url;
    @property(nonatomic, strong) GSFeedInfo *feed;
    @property(nonatomic, strong) NSMutableArray *items;
@end

@implementation GSRSSParser
- (id) initWithURL:(NSURL *)url delegate:(id)delg{
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void) parse{
    dispatch_queue_t kBgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:_url];
        NSError *error = nil;
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (str && [str length] > 0) {
            TBXML *tbxml = [[TBXML alloc] initWithXMLString:str error:&error];
            TBXMLElement * root = tbxml.rootXMLElement;
            _feed = [[GSFeedInfo alloc] initWithElement:root];
            NSString *itemName = _feed.fieldType == ftATOM ? @"entry" : @"item";
            
            TBXMLElement *e = [TBXML childElementNamed:itemName parentElement:_feed.firstItem];
            GSFeedItem *item = nil;
            while (e != nil) {
                item = [[GSFeedItem alloc] initWithElement:e andType:_feed.fieldType];
                e = [TBXML nextSiblingNamed:itemName searchFromElement:e];
            }
        }
    });
}
@end
