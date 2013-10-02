/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2009-2010 Ricardo Quesada
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * TMX Tiled Map support:
 * http://www.mapeditor.org
 *
 */

#import "CCTMXTiledMap.h"
#import "CCTMXXMLParser.h"
#import "CCTMXLayer.h"
#import "CCTMXObjectGroup.h"
#import "CCSprite.h"
#import "CCSpriteSheet.h"
#import "CCTextureCache.h"
#import "Support/CGPointExtension.h"


#pragma mark -
#pragma mark CCTMXTiledMap

@interface CCTMXTiledMap (Private)
-(id) parseLayer:(CCTMXLayerInfo*)layer map:(CCTMXMapInfo*)mapInfo;
-(CCTMXTilesetInfo*) tilesetForLayer:(CCTMXLayerInfo*)layerInfo map:(CCTMXMapInfo*)mapInfo;
@end

@interface CCTMXTiledMap()
@property(nonatomic, assign)BOOL hasResizedMap;
@end

@implementation CCTMXTiledMap
@synthesize hasResizedMap;
@synthesize mapSize=mapSize_;
@synthesize tileSize=tileSize_;
@synthesize mapOrientation=mapOrientation_;
@synthesize objectGroups=objectGroups_;
@synthesize properties=properties_;

+(id) tiledMapWithTMXFile:(NSString*)tmxFile{
	return [[[self alloc] initWithTMXFile:tmxFile] autorelease];
}

+(id) tiledMapWithTMXFile:(NSString*)tmxFile andResolvedPath:(NSString*)resolvePath{
	return [[[self alloc] initWithTMXFile:tmxFile andResolvedPath: resolvePath] autorelease];
}

- (void)setUpTmxFile:(CCTMXMapInfo*)mapInfo andSize:(CGSize)size{
	NSAssert( [mapInfo.tilesets count] != 0, @"TMXTiledMap: Map not found. Please check the filename.");
	[self setContentSize:CGSizeZero];

	if(size.width && size.height){
		mapSize_		= size;
		tileSize_		= size;
		hasResizedMap	= YES;		
	}else{
		mapSize_		= mapInfo.mapSize;
		tileSize_		= mapInfo.tileSize;
	}
	mapOrientation_ = mapInfo.orientation;
	objectGroups_	= [mapInfo.objectGroups retain];
	properties_		= [mapInfo.properties retain];
	tileProperties_ = [mapInfo.tileProperties retain];
	
	int idx=0;
	
	for( CCTMXLayerInfo *layerInfo in mapInfo.layers ) {
		
		if( layerInfo.visible ) {
			
			if(size.width && size.height) 
				layerInfo.layerSize = size;
			
			CCNode *child = [self parseLayer:layerInfo map:mapInfo];
			[self addChild:child z:idx tag:idx];
			
			// update content size with the max size
			CGSize childSize = [child contentSize];
			CGSize currentSize = [self contentSize];
			currentSize.width = MAX( currentSize.width, childSize.width );
			currentSize.height = MAX( currentSize.height, childSize.height );
			[self setContentSize:currentSize];
			
			idx++;
		}			
	}
}

- (id)initWithTMXFile:(NSString*)tmxFile imageToReplace:(NSDictionary*)replacement resolvedPath:(NSString*)resolvePath andMapSize:(CGSize)size{
	NSAssert(tmxFile, @"TMXTiledMap: tmx file and resolePath should not be nil");
	
	if ((self=[super init])) {
		[self setUpTmxFile: [CCTMXMapInfo formatWithTMXFile: tmxFile imageSource: nil imagesToReplace: replacement resolveLinkPath: resolvePath]
				   andSize: size];
	}
	return self;
}

//
- (id)initWithTMXFile:(NSString*)tmxFile imageSource:(NSString*)imgSource replaceWith:(NSString*)imgToReplace resolvedPath:(NSString*)resolvePath andMapSize:(CGSize)size{
	NSAssert(tmxFile, @"TMXTiledMap: tmx file and resolePath should not be nil");
	
	if ((self=[super init])) {
		[self setUpTmxFile: [CCTMXMapInfo formatWithTMXFile: tmxFile imageSource: imgSource imageToReplace: imgToReplace resolveLinkPath: resolvePath]
				   andSize: size];
	}
	return self;
}

- (id)initWithTMXFile:(NSString*)tmxFile andResolvedPath:(NSString*)resolvePath{
	NSAssert(tmxFile != nil, @"TMXTiledMap: tmx file should not be nil");
	
	if ((self=[super init])) {
		[self setUpTmxFile: [CCTMXMapInfo formatWithTMXFile:tmxFile resolveLinkPath: resolvePath]
				   andSize: CGSizeZero];
	}
	
	return self;
}

- (id)initWithTMXFile:(NSString*)tmxFile andMapSize:(CGSize)size{
	NSAssert(tmxFile != nil, @"TMXTiledMap: tmx file should not be nil");
	
	if ((self=[super init])) {
		[self setUpTmxFile: [CCTMXMapInfo formatWithTMXFile:tmxFile]
				   andSize: size];
	}
	
	return self;
}

- (id) initWithTMXFile:(NSString*)tmxFile{
	NSAssert(tmxFile != nil, @"TMXTiledMap: tmx file should not bi nil");

	if ((self=[super init])) {
		[self setUpTmxFile: [CCTMXMapInfo formatWithTMXFile:tmxFile]
				   andSize: CGSizeZero];
	}

	return self;
}

-(void) dealloc{
	[objectGroups_		release];
	[properties_		release];
	[tileProperties_	release];
	[super				dealloc];
}

// private
-(id) parseLayer:(CCTMXLayerInfo*)layerInfo map:(CCTMXMapInfo*)mapInfo
{
	CCTMXTilesetInfo *tileset = [self tilesetForLayer:layerInfo map:mapInfo];
	CCTMXLayer *layer = [CCTMXLayer layerWithTilesetInfo:tileset layerInfo:layerInfo mapInfo:mapInfo];

	// tell the layerinfo to release the ownership of the tiles map.
	layerInfo.ownTiles = NO;

	[layer setupTiles];
	
	return layer;
}

-(CCTMXTilesetInfo*) tilesetForLayer:(CCTMXLayerInfo*)layerInfo map:(CCTMXMapInfo*)mapInfo
{
	CCTMXTilesetInfo *tileset = nil;
	CFByteOrder o = CFByteOrderGetCurrent();
	
	CGSize size = layerInfo.layerSize;

	id iter = [mapInfo.tilesets reverseObjectEnumerator];
	for( CCTMXTilesetInfo* tileset in iter) {
		for( unsigned int y=0; y < size.height; y++ ) {
			for( unsigned int x=0; x < size.width; x++ ) {
				
				unsigned int pos = x + size.width * y;
				unsigned int gid = layerInfo.tiles[ pos ];
				
				// gid are stored in little endian.
				// if host is big endian, then swap
				if( o == CFByteOrderBigEndian )
					gid = CFSwapInt32( gid );
				
				// XXX: gid == 0 --> empty tile
				if( gid != 0 ) {
					
					// Optimization: quick return
					// if the layer is invalid (more than 1 tileset per layer) an assert will be thrown later
					if( gid >= tileset.firstGid )
						return tileset;
				}
			}
		}		
	}
	
	// If all the tiles are 0, return empty tileset
	CCLOG(@"cocos2d: Warning: TMX Layer '%@' has no tiles", layerInfo.name);
	return tileset;
}


// public
-(CGSize)getTotalSize{
	CGSize totalSize = CGSizeMake(tileSize_.width	* mapSize_.width,
								  tileSize_.height	* mapSize_.height);
	
	if ([UIScreen instancesRespondToSelector:@selector(scale)]){
		if ([[UIScreen mainScreen] scale] > 1.0){
			totalSize.width		/= 2;
			totalSize.height	/= 2;
		}
	}
	
	return totalSize;
}

-(CCTMXLayer*) layerNamed:(NSString *)layerName 
{
	for( CCTMXLayer *layer in children_ ) {
		if([layer isKindOfClass:[CCTMXLayer class]]){
			if( [layer.layerName isEqual:layerName] )
				return layer;
		}
	}
	
	// layer not found
	return nil;
}

-(CCTMXObjectGroup*) objectGroupNamed:(NSString *)groupName 
{
	for( CCTMXObjectGroup *objectGroup in objectGroups_ ) {
		if( [objectGroup.groupName isEqual:groupName] )
			return objectGroup;
		}
	
	// objectGroup not found
	return nil;
}

// XXX deprecated
-(CCTMXObjectGroup*) groupNamed:(NSString *)groupName 
{
	return [self objectGroupNamed:groupName];
}

-(id) propertyNamed:(NSString *)propertyName 
{
	return [properties_ valueForKey:propertyName];
} 

-(NSDictionary*)propertiesForGID:(unsigned int)GID{
	return [tileProperties_ objectForKey:[NSNumber numberWithInt:GID]];
}
@end

