//
//  GSRSSParser.h
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSFeedInfo;
@class GSFeedItem;
@class GSRSSParser;

@protocol GSRSSParserDelegate <NSObject>

@optional
- (void) parser:(GSRSSParser *)parser parsedFeedInfo:(GSFeedInfo *)info;
- (void) parser:(GSRSSParser *)parser parsedFeedItem:(GSFeedItem *)item;
- (void) parserDidFinish:(GSRSSParser *)parser;
- (void) parser:(GSRSSParser *)parser didFailWithError:(NSError *)error;
@end

@interface GSRSSParser : NSObject
@property(nonatomic, assign) id<GSRSSParserDelegate>delegate;
- (id) initWithURL:(NSURL *)url delegate:(id)delg;
- (void) parse;
@end
