//
//  SpriteKit_Easing.h
//  SpriteKit-Easing
//
//  Created by Andrew Eiche on 10/20/13.
//  Copyright (c) 2013 Birdcage Games LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface XSharderCenter : NSObject

+(SKShader*)getSound:(float)nodeWidth nodeHeight:(float)nodeHeight offsetX:(float)offsetX offsetY:(float)offsetY soundNote:(float)soundNote;
@end
