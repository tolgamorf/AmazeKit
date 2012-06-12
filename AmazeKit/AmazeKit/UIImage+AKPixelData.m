//
//  UIImage+AKPixelData.m
//  AmazeKit
//
//  Created by Jeffrey Kelley on 6/12/12.
//  Copyright (c) 2012 Detroit Labs. All rights reserved.
//


#import "UIImage+AKPixelData.h"


@implementation UIImage (AKPixelData)

- (NSData *)AK_rawARGB8888Data
{
	// First get the image into your data buffer
    CGImageRef imageRef = [self CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    uint8_t *rawData = (uint8_t*)calloc(height * width * 4, sizeof(uint8_t));
	
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
	
    CGContextRef context = CGBitmapContextCreate(rawData,
												 width,
												 height,
												 bitsPerComponent,
												 bytesPerRow,
												 colorSpace,
												 (kCGImageAlphaPremultipliedLast |
												  kCGBitmapByteOrder32Big));
    CGColorSpaceRelease(colorSpace);
	
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
	
	NSData *data = [[NSData alloc] initWithBytes:(const void *)rawData
										  length:height * width * 4 * sizeof(uint8_t)];
	
	free(rawData);
	
	return data;
}

@end