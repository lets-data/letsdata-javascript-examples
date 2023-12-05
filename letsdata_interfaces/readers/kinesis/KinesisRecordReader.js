
import { v4 as uuidv4 } from 'uuid';
import { RecordParseHint } from '../model/RecordParseHint.js';
import { RecordHintType } from '../model/RecordHintType.js';
import { ParseDocumentResult } from '../model/ParseDocumentResult.js';
import { ParseDocumentResultStatus } from '../model/ParseDocumentResultStatus.js';
import { Document } from '../../documents/Document.js';
import { DocumentType } from '../../documents/DocumentType.js';
import { ErrorDoc } from '../../documents/ErrorDoc.js';
import { logger } from '../../../letsdata_utils/logging_utils.js';

export class KinesisRecordReader {
    constructor() {

    }
        
    /**
    The Implementation simply echoes the incoming record. You could add custom logic as needed.
     */
     parseMessage(streamArn, shardId, partitionKey, sequenceNumber, approximateArrivalTimestamp, data) {
        if (!data || data.length <= 0) {
            logger.error(`record data is null or empty, returning error - streamArn: ${streamArn}, shardId: ${shardId}, partitionKey: ${partitionKey}, sequenceNumber: ${sequenceNumber}, approximateArrivalTimestamp: ${approximateArrivalTimestamp}, data: ${data}`);
            const errorDoc = new ErrorDoc(uuidv4(), "KINESIS_ERROR", partitionKey, {}, {}, { "sequenceNumber": sequenceNumber }, { "sequenceNumber": sequenceNumber }, "empty message body");
            return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.ERROR);
        }
    
        try {
            logger.debug(`processing record - sequenceNumber: ${sequenceNumber}`);
            const keyValuesMap = JSON.parse(new TextDecoder().decode(data));
            logger.debug(`returning success - docId: ${keyValuesMap.documentId}`);
            return new ParseDocumentResult(null, new Document(DocumentType.Document, keyValuesMap.documentId, "DOCUMENT", partitionKey, {}, keyValuesMap),  ParseDocumentResultStatus.SUCCESS);
        } catch (ex) {
            logger.error(`Exception in reading the document - streamArn: ${streamArn}, shardId: ${shardId}, partitionKey: ${partitionKey}, sequenceNumber: ${sequenceNumber}, approximateArrivalTimestamp: ${approximateArrivalTimestamp}, data: ${data}, ex: ${ex}`);
            const errorDoc = new ErrorDoc(uuidv4(), "KINESIS_ERROR", partitionKey, {}, {}, { "sequenceNumber": sequenceNumber }, { "sequenceNumber": sequenceNumber }, `Exception - ${ex}`);
            return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.ERROR);
        }
    }
}