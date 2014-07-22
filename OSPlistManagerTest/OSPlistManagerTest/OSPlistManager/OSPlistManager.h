//
//  PlistManager.h
//  PlistManager
//
//  Created by Chris Birch on 22/04/2013.
//  Copyright (c) 2013 OcastaStudios. All rights reserved.
//

/**
 * Purpose: To load all plists described in the OSPlistManagerDescriptors.plist and to allow easy access to their contents using a shared instance
 */
#import <Foundation/Foundation.h>


@interface OSPlistManager : NSObject


/**
 * An array containing OSPlistDescriptor pointers that describe where to find the plists that we are to load in
 */
@property(nonatomic,strong) NSMutableArray* plistDescriptors;

/**
 * A dictionary containing OSPlistDescriptor pointers that describe where to find the plists that we are to load in.
 * The dictionary key is the name as described in the OSPlistDescriptor
 */
@property(nonatomic,strong) NSMutableDictionary* loadedPlists;

/**
 * YES if we should print verbose logging info to console
 */
@property (nonatomic,assign) BOOL debugLoggingEnabled;


#pragma mark -
#pragma mark Shared

/**
 * Gets a shared PlistManager instance
 */
+(OSPlistManager*)shared;

#pragma mark -
#pragma mark Load plists

/**
 * Wipes the plistDescriptors array and repopulates it from the OSPlistManagerPlistDescriptors file
 */
-(BOOL)loadPListDescriptors;

/**
 * Loads all the plists as described by the descriptors in the descriptors array. If any of the plists fail
 * to load, the entire operation is aborted
 */
-(BOOL)reloadPlists;


#pragma mark -
#pragma mark Accessing loaded plists

/**
 * Returns an array for the specified plistname. NB this is the plist name, not the name of the file.
 * If the plist has not been loaded then nil is returned.
 */
-(NSArray*)arrayForPlistName:(NSString*)plistName;


/**
 * Returns an array for the specified plistname. NB this is the plist name, not the name of the file.
 * If the plist has not been loaded then nil is returned.
 */
-(NSDictionary*)dictionaryForPlistName:(NSString*)plistName;

@end
