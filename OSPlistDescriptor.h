//
//  OSPlistDescriptor.h
//  PlistManager
//
//  Created by Chris Birch on 22/04/2013.
//  Copyright (c) 2013 OcastaStudios. All rights reserved.
//

/**
 * Describes a plist loaded from the main bundle
 */

#import <Foundation/Foundation.h>

@interface OSPlistDescriptor : NSObject

/**
 * The name of the plist file contained within the bundle
 */
@property(nonatomic,strong) NSString*plistName;

/**
 * Describes whether or not the top level of this plist is an array. If NO then the top level is a dictionary
 */
@property(nonatomic,assign) BOOL isTopLevelAnArray;
@end
