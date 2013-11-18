//
//  TBFingerprintCell.m
//  Cryptocat
//
//  Created by Thomas Balthazar on 13/11/13.
//  Copyright (c) 2013 Thomas Balthazar. All rights reserved.
//

#import "TBFingerprintCell.h"

#define kPaddingH 7.0

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TBFingerprintCell ()

@property (nonatomic, strong) UILabel *label;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TBFingerprintCell

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self=[super initWithCoder:aDecoder]) {
    _label = [[UILabel alloc] init];
    _label.font = [UIFont fontWithName:@"Courier New" size:11.5];
    [self.contentView addSubview:_label];
  }
  
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect frame = self.contentView.frame;
  frame.origin.x+=kPaddingH;
  frame.size.width-=(2*kPaddingH);
  self.label.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFingerprint:(NSString *)fingerprint {
  self.label.text = fingerprint;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)fingerprint {
  return self.label.text;
}

@end