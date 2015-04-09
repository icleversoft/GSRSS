//
//  GSFullFeedItem.m
//  GSRSS
//
//  Created by George Stavrou on 4/15/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSFullFeedItem.h"

@implementation GSFullFeedItem
//@synthesize image = _image, title = _title, description = _description, author = _author, timeAgo = _timeAgo;
//@synthesize fullLink = _fullLink;

- (id) initWithFeedItem:(GSFeedItem *)item{
    if (self = [super initWithFeedItem:item]) {
        id val = nil;
        val = [item valueForKey:@"content:encoded"];
        if (val == nil) {
            val = [item valueForKey:@"description"];
        }
        //Description
        if (val == nil) {
            val = [item valueForKey:@"atom:summary"];
        }
        if (val != nil) {
            self.description = (NSString *)val;
        }

    }
    return self;
}

@end
