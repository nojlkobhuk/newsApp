//
//  NODParser.h
//  radioNOD
//
//  Created by in5630 on 13.01.15.
//  Copyright (c) 2015 zhurbenko inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NODAppDelegate.h"
#import "NODParseList.h"

@interface NODParser : NSObject <NSXMLParserDelegate> {
    
    NODAppDelegate *app;
    NODParseList *theParseList;
    NSMutableString *currentElementValue;
    
}

-(id)initParser;


@end
