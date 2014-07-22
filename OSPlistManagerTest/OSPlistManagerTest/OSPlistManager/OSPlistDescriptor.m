//
//  OSPlistDescriptor.m
//  PlistManager
//
//  Created by Chris Birch on 22/04/2013.
//  Copyright (c) 2013 OcastaStudios. All rights reserved.
//

#import "OSPlistDescriptor.h"

@implementation OSPlistDescriptor

-(NSString *)description
{
    NSString* type = _isTopLevelAnArray ? @"Array" : @"Dictionary";
    
    return [[NSString alloc] initWithFormat:@"OSPlistDescriptor named: %@. Type: %@",_plistName,type];
}
@end
