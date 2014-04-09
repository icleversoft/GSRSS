//
//  GSFeedInfo.m
//  GSRSS
//
//  Created by George Stavrou on 4/7/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSFeedInfo.h"
@interface GSFeedInfo ()
@end

@implementation GSFeedInfo
@synthesize fieldType = _fieldType;
@synthesize firstItem = _firstItem;
- (id) initWithElement:(TBXMLElement *)elm{
    if (self = [super initWithElement:elm]) {
        if ([[TBXML elementName:elm] isEqualToString:@"rss"]) {
            _fieldType = ftRSS;
            [self processFeed:[TBXML childElementNamed:@"channel" parentElement:elm] forKeys:RSS_INFO_ITEMS];
        }else{
            _fieldType = ftATOM;
            [self processFeed:elm forKeys:ATOM_INFO_ITEMS];
        }
    }
    return self;
}

- (void) processFeed:(TBXMLElement *)elm forKeys:(NSArray *)keys{
//    id val = nil;
    _firstItem = elm;
    for (NSString *attr in keys) {
        if ([attr isMultiple]) {
            NSString *realKey = [attr substringFromIndex:1];
            NSString *rxx = [realKey parentElementName];
            TBXMLElement *px = [TBXML childElementNamed:rxx parentElement:elm];
            while (px != nil) {
                [self setElement:px forKey:attr];
                px = [TBXML nextSiblingNamed:rxx searchFromElement:px];
            }
        }else{
            [self setElement:elm forKey:attr];
        }
    }
}


@end
