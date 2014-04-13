//
//  GSFeedItem.h
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSRSSPrimitive.h"


#define RSS_ITEM_KEYS  @[@"title", @"link", @"comments", @"pubDate", @"dc:creator", @"*category", \
                         @"guid", @"description", @"content:encoded", @"wfw:commentRss", \
                         @"*media:content@url", @"*media:thumbnail@url", @"feedburner:origLink", @"author", \
                         @"atom:summary"]

#define ATOM_ITEM_KEYS  @[@"title", @"*link@href", @"published", @"updated", @"id", \
                        @"author|name", @"content", @"summary", @"*category@term", \
                        @"*media:thumbnail@url", @"author|email"]

@interface GSFeedItem : GSRSSPrimitive
- (id) initWithElement:(TBXMLElement *)elm andType:(GSFeedType)fieldType;
@property (nonatomic, readonly) GSFeedType type;
@end
