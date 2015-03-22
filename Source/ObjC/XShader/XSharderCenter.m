//
//  SpriteKit_Easing.m
//  SpriteKit-Easing
//
//  Created by Andrew Eiche on 10/20/13.
//  Copyright (c) 2013 Birdcage Games LLC. All rights reserved.
//

#import "XSharderCenter.h"

@implementation XSharderCenter

+(SKShader*)getSound:(float)nodeWidth nodeHeight:(float)nodeHeight offsetX:(float)offsetX offsetY:(float)offsetY soundNote:(float)soundNote{
    SKShader* shader = [SKShader shaderWithFileNamed:@"Sound"];
    shader.uniforms = @[
                        [SKUniform uniformWithName:@"iResolution" floatVector3:GLKVector3Make(nodeWidth, nodeHeight, 0)],
                        [SKUniform uniformWithName:@"iMouse" floatVector3:GLKVector3Make(offsetX, offsetY, 0)],
                        
                        [SKUniform uniformWithName:@"iChannel0" floatVector3:GLKVector3Make(soundNote, 0, 0)],
                        
                        [SKUniform uniformWithName:@"iChannel1" texture:[SKTexture textureWithImageNamed:@"tex10"]],
                        ];
    return shader;
}
@end
