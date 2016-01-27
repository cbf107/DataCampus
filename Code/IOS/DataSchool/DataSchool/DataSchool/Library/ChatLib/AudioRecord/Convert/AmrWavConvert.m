//
//  AmrWavConvert.m
//  MarketEleven
//
//  Created by bergren on 15/3/23.
//  Copyright (c) 2015年 Meinekechina. All rights reserved.
//
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>

#import "AmrWavConvert.h"
#include "interf_enc.h"
#include "interf_dec.h"

const int sizes[] = { 12, 13, 15, 17, 19, 20, 26, 31, 5, 6, 5, 5, 0, 0, 0, 0 };

extern void* wav_write_open(const char *filename, int sample_rate, int bits_per_sample, int channels);
extern void wav_write_close(void* obj);
extern void wav_write_data(void* obj, const unsigned char* data, int length);

extern void* wav_read_open(const char *filename);
extern int wav_get_header(void* obj, int* format, int* channels, int* sample_rate, int* bits_per_sample, unsigned int* data_length);
extern int wav_read_data(void* obj, unsigned char* data, unsigned int length);
extern void wav_read_close(void* obj);


enum Mode findMode(const char* str) {
    struct {
        enum Mode mode;
        int rate;
    } modes[] = {
        { MR475,  4750 },
        { MR515,  5150 },
        { MR59,   5900 },
        { MR67,   6700 },
        { MR74,   7400 },
        { MR795,  7950 },
        { MR102, 10200 },
        { MR122, 12200 }
    };
    int rate = atoi(str);
    int closest = -1;
    int closestdiff = 0;
    unsigned int i;
    for (i = 0; i < sizeof(modes)/sizeof(modes[0]); i++) {
        if (modes[i].rate == rate)
            return modes[i].mode;
        if (closest < 0 || closestdiff > abs(modes[i].rate - rate)) {
            closest = i;
            closestdiff = abs(modes[i].rate - rate);
        }
    }
    fprintf(stderr, "Using bitrate %d\n", modes[closest].rate);
    return modes[closest].mode;
}

@implementation AmrWavConvert

+ (BOOL)convertAmrFile:(NSString *)amrFilePath toWAVFile:(NSString *)wavFilePath{
    
    const char *amrFileName = [amrFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    const char *wavFileName = [wavFilePath cStringUsingEncoding:NSUTF8StringEncoding];

    FILE *fpAmr = NULL;
    char header[6];
    NSInteger n;
    void *wav = NULL;
    void *amr = NULL;
    
    
    fpAmr = fopen(amrFileName, "rb");
    
    if (fpAmr == NULL) {
        return NO;
    }
    
    n = fread(header, 1, 6, fpAmr);
    if (n != 6 || memcmp(header, "#!AMR\n", 6)) {
        fprintf(stderr, "Bad header\n");
        return NO;
    }
    
    wav = wav_write_open(wavFileName, 8000, 16, 1);
    if (!wav) {
        fprintf(stderr, "Unable to open %s\n", wavFileName);
        return NO;
    }
    
    amr = Decoder_Interface_init();
    
    while (1) {
        uint8_t buffer[500], littleendian[320], *ptr;
        int size, i;
        int16_t outbuffer[160];
        /* Read the mode byte */
        n = fread(buffer, 1, 1, fpAmr);
        if (n <= 0)
            break;
        /* Find the packet size */
        size = sizes[(buffer[0] >> 3) & 0x0f];
        n = fread(buffer + 1, 1, size, fpAmr);
        if (n != size)
            break;
        
        /* Decode the packet */
        Decoder_Interface_Decode(amr, buffer, outbuffer, 0);
        
        /* Convert to little endian and write to wav */
        ptr = littleendian;
        for (i = 0; i < 160; i++) {
            *ptr++ = (outbuffer[i] >> 0) & 0xff;
            *ptr++ = (outbuffer[i] >> 8) & 0xff;
        }
        wav_write_data(wav, littleendian, 320);
    }
    
    fclose(fpAmr);
    Decoder_Interface_exit(amr);
    wav_write_close(wav);
    
    return YES;
}

+ (BOOL)convertWAVFile:(NSString *)wavFilePath toAmrFile:(NSString *)amrFilePath{
    
    const char *amrFileName = [amrFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    const char *wavFileName = [wavFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    
    enum Mode mode = MR122;
    int dtx = 0;
    const char *infile, *outfile;
    infile = wavFileName;
    outfile = amrFileName;
    
    FILE *fpOut;
    void *wav, *amr;
    int format, sampleRate, channels, bitsPerSample;
    int inputSize;
    uint8_t* inputBuf;
    
    wav = wav_read_open(infile);
    if (!wav) {
        fprintf(stderr, "Unable to open wav file %s\n", infile);
        return NO;
    }
    if (!wav_get_header(wav, &format, &channels, &sampleRate, &bitsPerSample, NULL)) {
        fprintf(stderr, "Bad wav file %s\n", infile);
        return NO;
    }
    if (format != 1) {
        fprintf(stderr, "Unsupported WAV format %d\n", format);
        return NO;
    }
    if (bitsPerSample != 16) {
        fprintf(stderr, "Unsupported WAV sample depth %d\n", bitsPerSample);
        return NO;
    }
    if (channels != 1)
        fprintf(stderr, "Warning, only compressing one audio channel\n");
    if (sampleRate != 8000)
        fprintf(stderr, "Warning, AMR-NB uses 8000 Hz sample rate (WAV file has %d Hz)\n", sampleRate);
    inputSize = channels*2*160;
    inputBuf = (uint8_t*) malloc(inputSize);
    
    amr = Encoder_Interface_init(dtx);
    fpOut = fopen(outfile, "wb");
    if (!fpOut) {
        perror(outfile);
        return NO;
    }
    
    fwrite("#!AMR\n", 1, 6, fpOut);
    while (1) {
        short buf[160];
        uint8_t outbuf[500];
        int read, i, n;
        read = wav_read_data(wav, inputBuf, inputSize);
        read /= channels;
        read /= 2;
        if (read < 160)
            break;
        for (i = 0; i < 160; i++) {
            const uint8_t* in = &inputBuf[2*channels*i];
            buf[i] = in[0] | (in[1] << 8);
        }
        n = Encoder_Interface_Encode(amr, mode, buf, outbuf, 0);
        fwrite(outbuf, 1, n, fpOut);
    }
    free(inputBuf);
    fclose(fpOut);
    Encoder_Interface_exit(amr);
    wav_read_close(wav);
    
    
    return YES;
}
@end
