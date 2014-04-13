//
//  GSBriefFeedItem.h
//  GSRSS
//
//  Created by George Stavrou on 4/13/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSFeedItem.h"
@interface GSBriefFeedItem : NSObject
- (id) initWithFeedItem:(GSFeedItem *)item;
@property (nonatomic, strong, readonly) NSString *image;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *description;
@property (nonatomic, strong, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSString *timeAgo;
@property (nonatomic, strong, readonly) NSString *fullLink;
@end
