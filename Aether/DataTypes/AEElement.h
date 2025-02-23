//
//  AEElement.h
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import <Foundation/Foundation.h>


@class AEComponent;

@interface AEElement : NSObject


- (AEComponent*)GetComponent;

- (void)Init;
- (void)Update;
- (void)Unload;

- (BOOL)IsBehaviour;


@end


