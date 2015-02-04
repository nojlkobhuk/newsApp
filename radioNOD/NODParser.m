//
//  NODParser.m
//  radioNOD
//
//  Created by in5630 on 13.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import "NODParser.h"

@implementation NODParser

-(id) initParser {
    
    if (self == [super init]) {
        app = (NODAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"channel"]) {
        app.listArray = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:@"item"]) {
        theParseList = [[NODParseList alloc] init];
        self->currentElementValue = nil;
        }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (!currentElementValue) {
        currentElementValue = [[NSMutableString alloc] initWithString:@""];
    }
    else {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [currentElementValue appendString:string];
    }

}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"channel"]) {
        return;
    }
    else if ([elementName isEqualToString:@"item"]) {
        [app.listArray addObject:theParseList];
    }
    else if (![elementName isEqualToString:@"rss"]) {
        [theParseList setValue:currentElementValue forKey:elementName];
        self->currentElementValue = nil;
        NSLog(@"title %@", theParseList.title);
        NSLog(@"Key %@", elementName);
    }
}

@end
