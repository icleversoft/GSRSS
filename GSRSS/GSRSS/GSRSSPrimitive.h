//
//  GSRSSPrimitive.h
//  GSRSS
//
//  Created by George Stavrou on 4/8/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "NSDate+InternetDateTime.h"
#import "NSDate+TimeAgo.h"

@interface NSString (RSSAttributes)
- (BOOL) isMultiple;
- (NSString *)parentElementName;
@end

typedef enum {ftRSS, ftATOM} GSFeedType;
@interface GSRSSPrimitive : NSObject
@property (nonatomic, strong) NSMutableDictionary *rssDictionary;

- (id) initWithElement:(TBXMLElement *)elm;
- (id) simpleValueFromKey:(NSString *)key andElement:(TBXMLElement *)elm;
- (id) valueFromKey:(NSString *)key andElement:(TBXMLElement *)elm;
- (void) setElement:(TBXMLElement *)elm forKey:(NSString *)key;
- (void) setValue:(id)value forAttribute:(NSString *)attr;
- (NSArray *)properties;
- (id) valueForKey:(NSString *)key;

@end
