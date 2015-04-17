//
//  CustomDatePicker.h
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinceDatePicker : UIView

@property (strong, nonatomic) NSString *colorScheme;

@property (strong, nonatomic) NSDate *date;

- (id)init;

@end
