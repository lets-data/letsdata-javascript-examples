
import { v4 as uuidv4 } from 'uuid';
import { RecordParseHint } from '../model/RecordParseHint.js';
import { RecordHintType } from '../model/RecordHintType.js';
import { ParseDocumentResult } from '../model/ParseDocumentResult.js';
import { ParseDocumentResultStatus } from '../model/ParseDocumentResultStatus.js';
import { Document } from '../../documents/Document.js';
import { DocumentType } from '../../documents/DocumentType.js';
import { ErrorDoc } from '../../documents/ErrorDoc.js';
import { logger } from '../../../letsdata_utils/logging_utils.js';

export class QueueMessageReader {
    constructor() {

    }
        
    /**
     The Implementation simply echoes the incoming record. You could add custom logic as needed.

     * @param messageId The SQS message messageId
     * @param messageGroupId The SQS message messageGroupId
     * @param messageDeduplicationId The SQS message messageDeduplicationId
     * @param messageAttributes The SQS message messageAttributes
     * @param messageBody The SQS message messageBody
     * @return ParseDocumentResult which has the extracted document and the status (error, success or skip)
     */
     parseMessage(messageId, messageGroupId, messageDeduplicationId, messageAttributes, messageBody) {
        if (!messageBody.trim()) {
            logger.debug(`message body is blank, returning error - messageId: ${messageId}, messageGroupId: ${messageGroupId}, messageDeduplicationId: ${messageDeduplicationId}, messageAttributes: ${JSON.stringify(messageAttributes)}, messageBody: ${messageBody}`);
            const errorDoc = new ErrorDoc(uuidv4(), "SQS_ERROR", messageId, {}, {}, null, null, "empty message body");
            return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.ERROR);
        }
    
        try {
            logger.debug(`processing message - messageId: ${messageId}`);
            const keyValuesMap = JSON.parse(messageBody);
            logger.debug(`returning success - docId: ${keyValuesMap.documentId}`);
            return new ParseDocumentResult(uuidv4(), new Document(DocumentType.Document, keyValuesMap.documentId, "DOCUMENT", keyValuesMap.partitionKey, {}, keyValuesMap), ParseDocumentResultStatus.SUCCESS);
        } catch (ex) {
            logger.debug(`JSONDecodeError in reading the document - messageId: ${messageId}, messageGroupId: ${messageGroupId}, messageDeduplicationId: ${messageDeduplicationId}, messageAttributes: ${JSON.stringify(messageAttributes)}, messageBody: ${messageBody}`);
            const errorDoc = new ErrorDoc(uuidv4(), null, `JSONDecodeError - ${ex.message}`, messageId, null, null, `JSONDecodeError - ${ex.message}`, messageBody);
            return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.ERROR);
        }
    }
}