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
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *timeAgo;
@property (nonatomic, strong) NSString *fullLink;
@property (nonatomic, strong) NSString *commentsURL;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSDate *date;
@end
