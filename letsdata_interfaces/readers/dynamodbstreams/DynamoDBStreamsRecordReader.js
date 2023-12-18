
import { v4 as uuidv4 } from 'uuid';
import { RecordParseHint } from '../model/RecordParseHint.js';
import { RecordHintType } from '../model/RecordHintType.js';
import { ParseDocumentResult } from '../model/ParseDocumentResult.js';
import { ParseDocumentResultStatus } from '../model/ParseDocumentResultStatus.js';
import { Document } from '../../documents/Document.js';
import { DocumentType } from '../../documents/DocumentType.js';
import { ErrorDoc } from '../../documents/ErrorDoc.js';
import { logger } from '../../../letsdata_utils/logging_utils.js';

export class DynamoDBStreamsRecordReader {
    constructor() {

    }
        
    /**
     * An example implementation that simply echoes the incoming record. You could add custom logic as needed.
     * 
     * For detailed explanation of the parameters, see AWS docs:
     *  * https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_streams_Record.html
     *  * https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_streams_StreamRecord.html
     * @param streamArn - The DynamoDB Stream ARN
     * @param shardId - The DynamoDB Shard Id
     * @param eventId - A globally unique identifier for the event that was recorded in this stream record.
     * @param eventName - The type of data modification that was performed on the DynamoDB table. INSERT | MODIFY | REMOVE
     * @param identityPrincipalId - The userIdentity's principalId
     * @param identityType - The userIdentity's principalType
     * @param sequenceNumber - The sequence number of the stream record
     * @param sizeBytes - The size of the stream record, in bytes
     * @param streamViewType - The stream view type - NEW_IMAGE | OLD_IMAGE | NEW_AND_OLD_IMAGES | KEYS_ONLY
     * @param approximateCreationDateTime - The approximate date and time when the stream record was created, in UNIX epoch time format and rounded down to the closest second
     * @param keys - The primary key attribute(s) for the DynamoDB item that was modified
     * @param oldImage - The item in the DynamoDB table as it appeared before it was modified
     * @param newImage - The item in the DynamoDB table as it appeared after it was modified
     * @return ParseDocumentResult which has the extracted document and the status (error, success or skip)
     */
    parseRecord(streamArn, shardId, eventId, eventName, identityPrincipalId, identityType, sequenceNumber, sizeBytes, streamViewType, approximateCreationDateTime, keys, oldImage, newImage) {
        try {
            let docId = null;
        
            for (const keyValue of Object.values(keys)) {
                if (docId === null) {
                    docId = keyValue;
                } else {
                    docId += '|' + keyValue;
                }
            }
        
            if (!newImage || Object.keys(newImage).length <= 0) {
                logger.error(`newImage is null, returning skip - streamArn: ${streamArn}, shardId: ${shardId}, eventName: ${eventName}, sequenceNumber: ${sequenceNumber}, approximateArrivalTimestamp: ${approximateCreationDateTime}, keys: ${JSON.stringify(keys)}`);
                
                const errorDoc = new SkipDoc(docId, 'DYNAMODBSTREAMS_SKIP', docId, {}, {}, { "sequenceNumber": sequenceNumber }, { "sequenceNumber": sequenceNumber }, 'delete record');
                return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.SKIP);
            }
        
            logger.debug(`processing record - sequenceNumber: ${sequenceNumber}`);
            logger.debug(`returning success - docId: ${docId}`);
            
            return new ParseDocumentResult(null, new Document('Document', docId, 'DOCUMENT', docId, {}, newImage), ParseDocumentResultStatus.SUCCESS);
        } catch (ex) {
            logger.debug(`Exception in reading the document - streamArn: ${streamArn}, shardId: ${shardId}, eventName: ${eventName}, sequenceNumber: ${sequenceNumber}, approximateArrivalTimestamp: ${approximateCreationDateTime}, keys: ${JSON.stringify(keys)}, ex: ${ex}`);
            
            const docIdUUID = uuidv4();
            const errorDoc = new ErrorDoc(docIdUUID, 'DYNAMODBSTREAMS_ERROR', docIdUUID, {}, {}, { "sequenceNumber": sequenceNumber }, { "sequenceNumber": sequenceNumber }, `Exception - ${ex}`);
            return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.ERROR);
        }
    }          
}
