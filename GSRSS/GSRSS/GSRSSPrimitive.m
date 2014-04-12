//
//  GSRSSPrimitive.m
//  GSRSS
//
//  Created by George Stavrou on 4/8/14.
//  Copyright (c) 2014 icleversoft. All rights reserved.
//

#import "GSRSSPrimitive.h"
#import "NSString+HTML.h"
#import "GSLinkItem.h"

@implementation NSString (RSSAttributes)
- (BOOL) isMultiple{
    return [self hasPrefix:@"*"];
}
- (NSString *)parentElementName{
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"[@\\|]" options:0 error:nil];
    NSArray *matches = [re matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if ([matches count] > 0) {
        NSArray *elements = [self componentsSeparatedByString:@"|"];
        if ([elements count] == 1) {
            elements = [self componentsSeparatedByString:@"@"];
            return [elements objectAtIndex:0];
        }else{
            return [elements objectAtIndex:0];
        }
        
    }else{
        return self;
    }
}
@end

#pragma mark
@implementation GSRSSPrimitive
@synthesize rssDictionary = _rssDictionary;

- (id) initWithElement:(TBXMLElement *)elm{
    if (self = [super init]) {
        _rssDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
#pragma mark -
- (id) simpleValueFromKey:(NSString *)key andElement:(TBXMLElement *)elm{
    NSArray *elements = [key componentsSeparatedByString:@"@"];
    if ([elements count] > 1) {
        return [[GSLinkItem alloc] initWithItem:elm];
//        return [TBXML valueOfAttributeNamed:[elements objectAtIndex:1] forElement:elm];
    }
    return [TBXML textForElement:elm];
}
#pragma mark -
- (id) valueFromKey:(NSString *)key andElement:(TBXMLElement *)elm{
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"[@\\|]" options:0 error:nil];
    TBXMLElement *e = nil;
    NSArray *matches = [re matchesInString:key options:0 range:NSMakeRange(0, [key length])];
    if ([matches count] == 0) {
        e = [TBXML childElementNamed:key parentElement:elm];
        if (e != nil) {
            return [TBXML textForElement:e];
        }
        return nil;
    }
    NSArray *elements = [key componentsSeparatedByString:@"|"];
    if ([elements count] == 1) {
        elements = [key componentsSeparatedByString:@"@"];
        e = [TBXML childElementNamed:[elements objectAtIndex:0] parentElement:elm];
        if (e != nil) {
            return [[GSLinkItem alloc] initWithItem:e];
//            GSLinkItem *link = [[GSLinkItem alloc] initWithItem:e];
//            return @[[elements objectAtIndex:0], [TBXML valueOfAttributeNamed:[elements objectAtIndex:1] forElement:e] ];
        }
    }else{
        for (NSString *subKey in elements) {
            elm = [TBXML childElementNamed:subKey parentElement:elm];
            if (elm == nil) {
                break;
            }
        }
        if (elm != nil) {
            return @[[elements objectAtIndex:0], [TBXML textForElement:elm]];
        }
    }
    return nil;
}
#pragma mark -
- (void) setValue:(id)value forAttribute:(NSString *)attr{
    id val = [_rssDictionary objectForKey:[attr parentElementName]];
    if (val == nil) {
         [self.rssDictionary setObject:value forKey:[attr parentElementName]];
    }else{
        if ([val isKindOfClass:[NSArray class]]) {
            NSMutableArray *mx = [[NSMutableArray alloc] initWithArray:(NSArray *)val];
            [mx addObject:value];
            [self.rssDictionary setObject:mx forKey:[attr parentElementName]];
        }else{
            [self.rssDictionary setObject:@[val, value] forKey:[attr parentElementName]];
        }
    }
}
- (void) setElement:(TBXMLElement *)elm forKey:(NSString *)key{
    NSLog(@"%@", key);
    id val = nil;
    if ([key isMultiple]) {
        key = [key substringFromIndex:1];
        val = [self simpleValueFromKey:key andElement:elm];
    }else{
        val = [self valueFromKey:key andElement:elm];
    }
    if (val != nil) {
        if ([val isKindOfClass:[NSString class]]) {
            
            [self setValue:[val stringByConvertingHTMLToPlainText] forAttribute:key];
        }else if ([val isKindOfClass:[GSLinkItem class]]){
            [self setValue:val forAttribute:key];
        }
        else{
            NSArray *arrVal = (NSArray *)val;
            [self setValue:[arrVal objectAtIndex:1] forAttribute:[arrVal objectAtIndex:0]];
        }
    }
}
- (NSArray *)properties{
    return [self.rssDictionary allKeys];
}
- (id) valueForKey:(NSString *)key{
    if ([self.properties containsObject:key]) {
        return [self.rssDictionary objectForKey:key];
    }
    return nil;
}

@end
