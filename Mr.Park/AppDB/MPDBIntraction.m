//
//  MPDBIntraction.m
//  Mr.Park
//
//  Created by aditi on 02/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MPDBIntraction.h"
MPDBIntraction *databaseManager = nil;
@implementation MPDBIntraction
@synthesize databaseName;
+ (id)databaseInteractionManager
{
    @synchronized(self)
    {
        if (databaseManager == nil)
        {
            databaseManager = [[self alloc] init];
        }
    }
    return databaseManager;
}
- (id)init
{
    if (self = [super init])
    {
        dBMrPark  = [[FMDatabase alloc] initWithPath:[self getDatabasePathFromName:DBname]];
    }
    return self;
}
- (NSString *) getDatabasePathFromName:(NSString *)dbName
{
	return [self getDatabaseFolderPath:dbName];
}

-(NSString *) getDatabaseFolderPath : (NSString *)dbName
{
	databaseName = [dbName stringByAppendingString:@".sqlite"];
	NSString *databasePath = [[self getDocumentsDirectoryPath] stringByAppendingPathComponent:databaseName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:databasePath]) return databasePath;
	else
    {
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	}
	return databasePath;
}

- (NSString *) getDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

@end
