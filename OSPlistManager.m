//
//  PlistManager.m
//  PlistManager
//
//  Created by Chris Birch on 22/04/2013.
//  Copyright (c) 2013 OcastaStudios. All rights reserved.
//

#import "OSPlistManager.h"
#import "OSPlistDescriptor.h"

#define PLISTFILE @"OSPListManagerPlistDescriptors"

//The name that the plist is refered to, this has to match the name of the plist file in the bundle. NB this is without the .plist extension
#define PLIST_ITEM_NAME @"Name"
////If YES describes that the top level of this plist is an array otherwise its a dictionary
#define PLIST_TOP_LEVEL_IS_ARRAY @"IsTopLevelArray"
@implementation OSPlistManager


-(id)init
{
    if (self = [super init])
    {
        _plistDescriptors = [[NSMutableArray alloc] init];
        _loadedPlists = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark Shared instance

static OSPlistManager* _shared=nil;

+(OSPlistManager *)shared
{
    @synchronized(_shared)
    {
        if (!_shared)
        {
            _shared = [[OSPlistManager alloc] init];
        }
    }
    
    return _shared;
}

#pragma mark -
#pragma mark Loading plists

-(BOOL)reloadPlists
{
    int loadedCount=0;
    
    [_loadedPlists removeAllObjects];
    
    for (OSPlistDescriptor* descriptor in _plistDescriptors)
    {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:descriptor.plistName ofType:@"plist"];
        
        //make sure the file exists
        if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath])
        {
            [self debugLog:[[NSString alloc] initWithFormat:@"PList file exists: %@", resourcePath]];
            
            //are we dealing with an array or a dictionary
            if (descriptor.isTopLevelAnArray)
            {
                NSArray* array = [[NSArray alloc] initWithContentsOfFile:resourcePath];
                
                //make sure we managed to load it
                if (array)
                {
                    [_loadedPlists setObject:array forKey:descriptor.plistName];
                    loadedCount++;
                }
                else
                {
                    [self debugLog:[[NSString alloc] initWithFormat:@"Aborting load! Failed to load array from plist: %@", resourcePath]];
                    return NO;
                }
            }
            else
            {
                NSDictionary* dictionary = [[NSDictionary alloc] initWithContentsOfFile:resourcePath];
                
                //make sure we managed to load it
                if (dictionary)
                {
                    [_loadedPlists setObject:dictionary forKey:descriptor.plistName];
                    loadedCount++;
                }
                else
                {
                    [self debugLog:[[NSString alloc] initWithFormat:@"Aborting load! Failed to load dictionary from plist: %@", resourcePath]];
                    return NO;
                }
            }
        }
        else
        {
            [self debugLog:[[NSString alloc] initWithFormat:@"Aborting load! PList file does not exist: %@", resourcePath]];
            return NO;
        }   
    }
    
    [self debugLog:[[NSString alloc] initWithFormat:@"Succesfully loaded %d plist files", loadedCount]];
    
    return YES;
}

-(BOOL)loadPListDescriptors
{
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:PLISTFILE ofType:@"plist"];
    
    [_plistDescriptors removeAllObjects];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath])
    {
        [self debugLog:[[NSString alloc] initWithFormat:@"PList file exists: %@", resourcePath]];
        
        NSArray *plists = [[NSArray alloc] initWithContentsOfFile:resourcePath];
        
        if (plists)
        {
            [self debugLog:[[NSString alloc] initWithFormat:@"PList loaded into array"]];
            
            for (NSDictionary* plistDescriptor in plists)
            {
                NSString* plistName = [plistDescriptor objectForKey:PLIST_ITEM_NAME];
                BOOL plistIsTopLevelAnArray = [(NSNumber*) [plistDescriptor objectForKey:PLIST_TOP_LEVEL_IS_ARRAY] boolValue];
                OSPlistDescriptor* descriptor = [[OSPlistDescriptor alloc] init];
                descriptor.plistName = plistName;
                descriptor.isTopLevelAnArray = plistIsTopLevelAnArray;
                
                //add to the descriptors array
                [_plistDescriptors addObject:descriptor];
                
                [self debugLog:[[NSString alloc] initWithFormat:@"Added Descriptor: %@",descriptor]];
            }
            
            [self debugLog:[[NSString alloc] initWithFormat:@"Succesfully parsed plist descriptors from plist"]];
            
            [_shared reloadPlists];
            
            return YES;
        }
        else
        {
            //Failed to parse plist
            [self debugLog:[[NSString alloc] initWithFormat:@"Failed to parse Plist file"]];
        }
    }
    else
    {
        [self debugLog:[[NSString alloc] initWithFormat:@"Failed to load Plist desciptor plist! Please make sure you have a file included in your bundle called: %@.plist", PLISTFILE]];
    }
    
    return NO;

}

#pragma mark -
#pragma mark Accessing loaded plists

-(NSArray*)arrayForPlistName:(NSString*)plistName
{
    if ([_loadedPlists.allKeys containsObject:plistName])
    {
        return [_loadedPlists objectForKey:plistName];
    }
    else
    {
        [self debugLog:[[NSString alloc] initWithFormat:@"Plist %@ doesn't exist in the loaded plist dictionary!", plistName]];
        return nil;
    }
}


-(NSDictionary*)dictionaryForPlistName:(NSString*)plistName
{
    if ([_loadedPlists.allKeys containsObject:plistName])
    {
        return [_loadedPlists objectForKey:plistName]; 
    }
    else
    {
        [self debugLog:[[NSString alloc] initWithFormat:@"Plist %@ doesn't exist in the loaded plist dictionary!", plistName]];
        return nil;
    }
}

#pragma mark -
#pragma mark Debug log

-(void)debugLog:(NSString*)message
{
    if (_debugLoggingEnabled)
        NSLog(@"OSPlistManager: %@",message);
}

@end
