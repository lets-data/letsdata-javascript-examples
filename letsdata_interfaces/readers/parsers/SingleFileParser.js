
import { v4 as uuidv4 } from 'uuid';
import { RecordParseHint } from '../model/RecordParseHint.js';
import { RecordHintType } from '../model/RecordHintType.js';
import { ParseDocumentResult } from '../model/ParseDocumentResult.js';
import { ParseDocumentResultStatus } from '../model/ParseDocumentResultStatus.js';
import { Document } from '../../documents/Document.js';
import { DocumentType } from '../../documents/DocumentType.js';
import { ErrorDoc } from '../../documents/ErrorDoc.js';
import { logger } from '../../../letsdata_utils/logging_utils.js';
import { letsdata_assert } from "../../../letsdata_utils/validations.js";

/*
    The parser interface for Single File Reader usecase. This is used when all the files are of a single type and the records in the file do not follow a state machine.
    This interface is where you tell us how to parse the individual records from the file. Since this is single file reader, there is no state machine maintained.
    
    This implementation parses the 'conversion' records from the Common Crawl Web Extraction Template (WET) files.

                Example: WET Files Record Layout:
                ---------------------------------

                'warcinfo' WARCINFO Header
                WARCINFO Payload

                'conversion' WARC Header
                'conversion' Payload

                'conversion' WARC Header
                'conversion' Payload

                'conversion' WARC Header
                'conversion' Payload

                ...
 */
export class SingleFileParser {
    constructor() {

    }
        

    /*
     * The filetype of the file - for the example we've used, we define the filetype (logical name) as "WET"
     * 
     * @return - The file type
     */
    getS3FileType() {
        return "WET";
    }

    /*
     * Given the filetype (WET) and filename (crawl-data/CC-MAIN-2022-21/segments/1652662509990.19/wet/CC-MAIN-20220516041337-20220516071337-00000.warc.wet.gz) from the manifest file, return the resolved filename if necessary.
     * In most cases, the resolved filename would be the same as the filename, but in some cases, you might need to prepend paths if the data in the s3 bucket is not in the root directory.
     * In this example, the manifest filename is fully qualified so we return it as is.
     *
     * @param s3FileType - the file type - example WET
     * @param fileName - the file name - example crawl-data/CC-MAIN-2022-21/segments/1652662509990.19/wet/CC-MAIN-20220516041337-20220516071337-00000.warc.wet.gz
     * @return - the resolved file name - example crawl-data/CC-MAIN-2022-21/segments/1652662509990.19/wet/CC-MAIN-20220516041337-20220516071337-00000.warc.wet.gz
     */
    getResolvedS3FileName(s3FileType, fileName) {
        return fileName;
    }


    /*
     * The record start pattern - to extract the records from the file, the parser needs to know the record start delimiter - it will search the file sequentially till it finds this delimiter and then from that point on, it will search for the end record delimiter.
     * Once it finds the end record delimiter, it will copy those bytes to the parse document function to create an extracted record
     *
     *      For example, here is an abbreviated WET file:
     *
     *      WET File:
     *      ---------
     * 
     *      WARC/1.0
     *      WARC-Type: conversion                                                   <--- we use this string as the start pattern
     *      WARC-Target-URI: http://023hrk.com/a/chanpinzhongxin/cp2/104.html
     *      WARC-Date: 2022-05-16T04:40:56Z
     *      WARC-Record-ID: <urn:uuid:f8a15ad2-9d24-42d6-8f7a-7d9431246752>
     *      WARC-Refers-To: <urn:uuid:5232afac-fb10-401c-b522-445db8bdbf2a>
     *      WARC-Block-Digest: sha1:M7TRGS3KUALFLHMGLJSDMER3FDP2Z2Q4
     *      WARC-Identified-Content-Language: zho
     *      Content-Type: text/plain
     *      Content-Length: 3710
     *      
     *      漫步肩关节_重庆鸿瑞铠体育设施有限公司
     *      网站地图
     *      加入收藏
     *      联系我们
     *      您好！欢迎访问重庆鸿瑞铠体育设施有限公司！
     *      优质环保原料
     *      更环保更安全
     *      施工保障
     *      流程严谨、匠心工艺
     *      使用年限
     *      高出平均寿命30%
     *      全国咨询热线
     *      ...
     *                                                                              <--- we use '\n\r\n\r\n' as the end pattern
     *
     *      WARC/1.0
     *      WARC-Type: conversion
     *      ...
     *
     *
     *
     * @param s3FileType - the filetype
     * @return - the record start pattern as a RecordParseHint object
     */
    getRecordStartPattern(s3FileType) {
        return new RecordParseHint(RecordHintType.PATTERN, "WARC-Type: conversion", -1)
    }
        
    
    /*
     * The record end pattern - to extract the records from the file, the parser needs to know the record start delimiter - it will search the file sequentially till it finds this delimiter and then from that point on, it will search for the end record delimiter.
     * Once it finds the end record delimiter, it will copy those bytes to the parse document function to create an extracted record
     *
     * See above for file structure. We use '\n\r\n\r\n' as the end pattern
     * @param s3FileType - the filetype
     * @return - the record end pattern as a RecordParseHint object
     */
    getRecordEndPattern(s3FileType) {
        return new RecordParseHint(RecordHintType.PATTERN, "\n\r\n\r\n", -1);
    }
    
    /*
     *  This function is called with the document contents in a byteArr and the startIndex and endIndex into the byteArr as the start and end of the record.
     *  The implementer is expected to construct the output record from these bytes.
     *
     *  The example implementation below parses the header key value pairs, extract the url as the docId, partitionKey and other headers as document attributes.
     *  We also extract the document text and return these as a document with Success status code.
     *
     * @param s3FileType - the filetype
     * @param s3Filename - the filename
     * @param offsetBytes - the offset bytes into the file
     * @param byteArr - the byteArr that has the contents of the record
     * @param startIndex - the start index of the record in the byteArr
     * @param endIndex - the end index of the record in the byteArr
     * @return - ParseDocumentResult which has the extracted record and the status (error, success or skip)
     */
    parseDocument(s3FileType, s3Filename, offsetBytes, byteArr, startIndex, endIndex) {
        const encoder = new TextEncoder();
        const decoder = new TextDecoder('utf-8');

        const headerEndIndex = this.findByteSequence(byteArr, new TextEncoder().encode('\r\n\r\n'), startIndex, endIndex);
        if (headerEndIndex === -1) {
            throw new Error(`Header end index not found in Http Response - start index: ${startIndex}, end index: ${endIndex}`);
        }

        const headerMap = {};
        let currIndex = startIndex;

        while (currIndex < headerEndIndex) {
            logger.debug(`loop iter - currIndex: ${currIndex}, headerEndIndex: ${headerEndIndex}`);
            const lineEndIndex = this.findByteSequence(byteArr, encoder.encode('\r\n'), currIndex, headerEndIndex);

            if (lineEndIndex <= currIndex) {
                logger.debug("lineEndIndex not found when parsing headers");
                break;
            }

            const line = decoder.decode(byteArr.subarray(currIndex, lineEndIndex)).trim();
            logger.debug(`parsed header line ${line}`);

            if (!line || line === "" || line.startsWith("WARC/1.0")) {
                currIndex = lineEndIndex + 2; // 2 is the length of '\r\n'
            } else {
                const colonIndex = line.indexOf(':');
                letsdata_assert(colonIndex > 0, "invalid header line");

                const headerKey = line.substring(0, colonIndex).trim();
                const headerValue = line.substring(colonIndex + 1).trim();

                logger.debug(`parsed headerKey: ${headerKey}, headerValue: ${headerValue}`);
                headerMap[headerKey] = headerValue;
                currIndex = lineEndIndex + 2; // 2 is the length of '\r\n'
            }
        }

        logger.debug(`parsed headerMap: ${JSON.stringify(headerMap)}`);
        
        const docKeyValueMap = {};

        currIndex = headerEndIndex;
        const docText = decoder.decode(byteArr.subarray(currIndex, endIndex)).trim();

        // letsdata_assert(docText.length > 0, "invalid docText");

        docKeyValueMap['docText'] = docText;

        const url = headerMap['WARC-Target-URI'];
        letsdata_assert(url.length > 0, "invalid url");
        docKeyValueMap['url'] = url;
        docKeyValueMap['docId'] = url;
        docKeyValueMap['partitionKey'] = url;

        const language = headerMap['WARC-Identified-Content-Language'] || null;
        if (language) {
            docKeyValueMap['language'] = language;
        }

        const contentType = headerMap['Content-Type'] || null;
        if (contentType) {
            docKeyValueMap['contentType'] = contentType;
        }

        const contentLength = headerMap['Content-Length'] || null;
        if (contentLength) {
            docKeyValueMap['contentLength'] = contentLength;
        }

        const blockDigest = headerMap['WARC-Block-Digest'] || null;
        if (blockDigest) {
            docKeyValueMap['blockDigest'] = blockDigest;
        }

        const warcDate = headerMap['WARC-Date'] || null;
        if (warcDate) {
            docKeyValueMap['warcDate'] = warcDate;
        }

        return new ParseDocumentResult(
            null,
            new Document(
                DocumentType.Document,
                url,
                "Content",
                url,
                {},
                docKeyValueMap
            ),
            ParseDocumentResultStatus.SUCCESS
        );
    }

    findByteSequence(byteArr, targetBytes, startIndex, endIndex) {
        for (let i = startIndex; i < endIndex - targetBytes.length + 1; i++) {
            let found = true;
            for (let j = 0; j < targetBytes.length; j++) {
                if (byteArr[i + j] !== targetBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return i;
            }
        }
        return -1;
    }
}