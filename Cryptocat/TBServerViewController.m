//
//  TBServerViewController.m
//  Cryptocat
//
//  Created by Thomas Balthazar on 25/11/13.
//  Copyright (c) 2013 Thomas Balthazar. All rights reserved.
//
//  This file is part of Cryptocat for iOS.
//
//  Cryptocat for iOS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Cryptocat for iOS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Cryptocat for iOS.  If not, see <http://www.gnu.org/licenses/>.
//

#import "TBServerViewController.h"
#import "TBTextFieldCell.h"
#import "TBServer.h"
#import "NSString+Cryptocat.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TBServerViewController ()

@property (nonatomic, readonly) BOOL isAddVC;
@property (weak, nonatomic) IBOutlet TBTextFieldCell *nameCell;
@property (weak, nonatomic) IBOutlet TBTextFieldCell *domainCell;
@property (weak, nonatomic) IBOutlet TBTextFieldCell *conferenceServerCell;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TBServerViewController

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // -- save button (for New or Edit not readonly)
  if (self.server==nil || !self.server.isReadonly) {
    NSString *saveTitle = TBLocalizedString(@"Save", @"Save Button Title");
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:saveTitle
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
  }
  
  // -- placeholder text
  self.nameCell.textField.placeholder = TBLocalizedString(@"Name", @"Server Name Placeholder");
  self.domainCell.textField.placeholder = TBLocalizedString(@"Domain",
                                                            @"Server Domain Placeholder");
  self.conferenceServerCell.textField.placeholder = TBLocalizedString(@"XMPP Conference Server",
                                                            @"Server XMPP Conference Placeholder");
  
  // -- textfield config
  self.nameCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  self.nameCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  self.domainCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  self.domainCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  self.conferenceServerCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  self.conferenceServerCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  
  NSString *screenTitle;
  if (self.isAddVC) {
    screenTitle = TBLocalizedString(@"New Server", @"New Server Screen Title");
    NSString *cancelTitle = TBLocalizedString(@"Cancel", @"Cancel Button Title");
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [self.nameCell.textField becomeFirstResponder];
  }
  else {
    screenTitle = self.server.name;
    if (self.server.isReadonly) {
      self.nameCell.enabled = NO;
      self.domainCell.enabled = NO;
      self.conferenceServerCell.enabled = NO;
    }
    
    self.nameCell.textField.text = self.server.name;
    self.domainCell.textField.text = self.server.domain;
    self.conferenceServerCell.textField.text = self.server.conferenceServer;
  }
  
  self.title = screenTitle;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isAddVC {
  return self.server==nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)save {
  if (self.isAddVC) {
    if ([self.delegate respondsToSelector:@selector(serverViewController:didCreateServer:)]) {
      TBServer *server = [[TBServer alloc] init];
      server.name = [self.nameCell.textField.text tb_trim];
      server.domain = [self.domainCell.textField.text tb_trim];
      server.conferenceServer = [self.conferenceServerCell.textField.text tb_trim];
      [self.delegate serverViewController:self didCreateServer:server];
    }
  }
  else {
    if ([self.delegate
         respondsToSelector:@selector(serverViewController:didUpdateServer:atIndexPath:)]) {
      self.server.name = [self.nameCell.textField.text tb_trim];
      self.server.domain = [self.domainCell.textField.text tb_trim];
      self.server.conferenceServer = [self.conferenceServerCell.textField.text tb_trim];
      [self.delegate serverViewController:self
                          didUpdateServer:self.server
                                  atIndexPath:self.serverIndexPath];
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(serverViewControllerDidCancel:)]) {
    [self.delegate serverViewControllerDidCancel:self];
  }
}

@end
