//
//  CustomDatePicker.h
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePicker : UIView

@property (strong, nonatomic) NSDictionary *colorScheme;

@property (strong, nonatomic, readonly) NSDate *date;

@end
