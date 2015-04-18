//
//  ViewController.h
//  Since
//
//  Created by Shane Carey on 3/24/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinceDataManager.h"

@interface SinceViewController : UIViewController <SinceDataManagerDelegate>

@property (strong, nonatomic) NSMutableDictionary *entry;

@end

