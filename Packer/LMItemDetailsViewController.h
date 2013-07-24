//
//  LMItemDetailsViewController.h
//  Packer
//
//  Created by Logan Moseley on 7/24/13.
//  Copyright (c) 2013 Logan Moseley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item, Box;

@interface LMItemDetailsViewController : UITableViewController
@property (nonatomic, weak) Item *item;
@end
