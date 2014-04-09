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
        _delegate = delg;
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
            @try {
                _feed = [[GSFeedInfo alloc] initWithElement:root];
                if (_delegate && [_delegate respondsToSelector:@selector(parser:parsedFeedInfo:)]) {
                    [_delegate parser:self parsedFeedInfo:_feed];
                }
                NSString *itemName = _feed.fieldType == ftATOM ? @"entry" : @"item";
                
                TBXMLElement *e = [TBXML childElementNamed:itemName parentElement:_feed.firstItem];
                GSFeedItem *item = nil;
                while (e != nil) {
                    item = [[GSFeedItem alloc] initWithElement:e andType:_feed.fieldType];
                    if (_delegate && [_delegate respondsToSelector:@selector(parser:parsedFeedItem:)]) {
                        [_delegate parser:self parsedFeedItem:item];
                    }
                    e = [TBXML nextSiblingNamed:itemName searchFromElement:e];
                }
                if (_delegate && [_delegate respondsToSelector:@selector(parserDidFinish:)]) {
                    [_delegate parserDidFinish:self];
                }
            }
            @catch (NSException *exception) {
                if (_delegate && [_delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
                    NSError *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
                    [_delegate parser:self didFailWithError:error];
                }
            }
        }
    });
}
@end
