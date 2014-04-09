//
//  GSFeedInfo.h
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSRSSPrimitive.h"

#define RSS_INFO_ITEMS  @[@"title", @"link", @"atom:link@href", @"description", @"lastBuildDate", @"language", \
                          @"managingEditor"@"sy:updatePeriod", @"sy:updateFrequency", @"generator", \
                          @"openSearch:totalResults", @"openSearch:startIndex", @"openSearch:itemsPerPage",\
                          @"atom:id", @"image|url", @"itunes:owner|itunes:email", @"itunes:explicit", \
                          @"itunes:subtitle", @"managingEditor", @"*category"]

#define ATOM_INFO_ITEMS  @[@"title", @"subtitle", @"link@href", @"id", @"updated", \
                          @"generator", @"*category@term"]

@interface GSFeedInfo : GSRSSPrimitive

@property (nonatomic, assign) GSFeedType fieldType;
@property (nonatomic, assign) TBXMLElement *firstItem;
@end
