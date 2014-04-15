//
//  GSFullFeedItem.h
//  GSRSS
//
//  Created by George Stavrou on 4/15/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSBriefFeedItem.h"

@interface GSFullFeedItem : GSBriefFeedItem
- (id) initWithFeedItem:(GSFeedItem *)item;
@property (nonatomic, strong, readonly) NSString *image;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSString *timeAgo;
@property (nonatomic, strong, readonly) NSString *fullLink;
@end
