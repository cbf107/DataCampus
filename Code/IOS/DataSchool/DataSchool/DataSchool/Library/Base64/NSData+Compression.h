//
//  NSData+Compression.h
//  
//
//  Created by apple on 13-4-26.
//  Copyright (c) 2013年 starcpt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Compression)
#pragma mark -#pragma mark Zlib Compression routines
/*! Returns a data object containing a Zlib decompressed copy of the receivers contents. 
 * \returns A data object containing a Zlib decompressed copy of the receivers contents. 
 */
- (NSData *) zlibInflate;
/*! Returns a data object containing a Zlib compressed copy of the receivers contents. 
 * \returns A data object containing a Zlib compressed copy of the receivers contents.
 */
- (NSData *) zlibDeflate;

#pragma mark -#pragma mark Gzip Compression routines
/*! Returns a data object containing a Gzip decompressed copy of the receivers contents. 
 * \returns A data object containing a Gzip decompressed copy of the receivers contents. 
 */
- (NSData *) gzipInflate;
/*! Returns a data object containing a Gzip compressed copy of the receivers contents. 
 * \returns A data object containing a Gzip compressed copy of the receivers contents. 
 */
- (NSData *) gzipDeflate;
@end
