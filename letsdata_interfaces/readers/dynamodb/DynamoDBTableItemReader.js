
import { v4 as uuidv4 } from 'uuid';
import { RecordParseHint } from '../model/RecordParseHint.js';
import { RecordHintType } from '../model/RecordHintType.js';
import { ParseDocumentResult } from '../model/ParseDocumentResult.js';
import { ParseDocumentResultStatus } from '../model/ParseDocumentResultStatus.js';
import { Document } from '../../documents/Document.js';
import { DocumentType } from '../../documents/DocumentType.js';
import { ErrorDoc } from '../../documents/ErrorDoc.js';
import { logger } from '../../../letsdata_utils/logging_utils.js';

export class DynamoDBTableItemReader {
    constructor() {

    }
        
    /**
     * The #LetsData DynamoDB Table Item Reader uses this interface's implementation (also called as user data handlers) to transform the records from DynamoDB Item to a #LetsData document. At a high level, the overall #LetsData DynamoDB Table Item Reader design is as follows:

     *  * #LetsData scans the DynamoDB table and passes the items to the user data handlers.
     *  * The user data handlers transform this record and returns a document.
     *  * #LetsData writes the document to the write / error destinations and checkpoints the DynamoDB table's location (lastEvaluatedKey)
     *  * For any errors in #LetsData DynamoDB Table Item Reader, or error docs being returned by the user data handler, #LetsData looks at the reader configuration and determines 1./ whether to fail the task with error 2./ or write an error doc and continue processing
     *  * If the decision is to continue processing, the reader polls for next record in the stream.

     +---------------------+                              +---------------------+                        +---------------------+
     | AWS DynamoDB Table  | ------ Read Items - -------> |    # Lets Data      |---- parseDocument ---> |  User Data Handler  |
     |       Scan          |                              |  DDB Table Reader   |<---- document -------- |                     |
     +---------------------+                              |                     |                        +---------------------+
                                                          |   Is Error Doc?     |
                                                          |        |            |                        +---------------------+
                                                          |        +---- yes ->-|---- write document --->|  Write Destination  |
                                                          |        |            |                        +---------------------+
                                                          |        |            |                        +---------------------+
                                                          |        +---- no -->-|---- write error ------>|  Error Destination  |
                                                          |        |            |                        +---------------------+
                                                          | Should Checkpoint?  |
                                                          |        |            |
               ---<------- Checkpoint Task --------<------|<- yes -+            |
                                                          |        |            |
                                                          |        |            |
                                                          | Throw on Error?     |
                                                          |<- yes -+            |
                                                          |        |            |
                                                          |        V            |
                                                          |  Throw on Error     |
                                                          +---------------------+

     * The DynamoDB Table Item read connector configuration has details about the DynamoDB Table Item read and on dealing with failures.
     * @param tableName - The DynamoDB tableName
     * @param segmentNumber - The DynamoDB scan segmentNumber
     * @param keys - The primary key attribute(s) for the scanned DynamoDB item
     * @param item - The scanned item from the DynamoDB table
     * @return ParseDocumentResult which has the extracted document and the status (error, success or skip)
     */
    parseDynamoDBItem(tableName, segmentNumber, keys, item) {
        try {
            let docId = null;
        
            for (const keyValue of Object.values(keys)) {
                if (docId === null) {
                    docId = keyValue;
                } else {
                    docId += '|' + keyValue;
                }
            }
        
            if (!item || Object.keys(item).length <= 0) {
                logger.error(`item is null, returning error - tableName: ${tableName}, segmentNumber: ${segmentNumber}, keys: ${JSON.stringify(keys)}`);
                
                const errorDoc = new ErrorDoc(docId, 'DDB_ERROR', docId, {}, {}, { "keys": keys }, { "keys": keys }, 'error record');
                return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.ERROR);
            }
        
            logger.debug(`processing record, returning success - docId: ${docId}`);
            
            return new ParseDocumentResult(null, new Document('Document', docId, 'DOCUMENT', docId, {}, item), ParseDocumentResultStatus.SUCCESS);
        } catch (ex) {
            logger.debug(`Exception in reading the document - tableName: ${tableName}, segmentNumber: ${segmentNumber}, keys: ${JSON.stringify(keys)}, ex: ${ex}`);
            
            const docIdUUID = uuidv4();
            const errorDoc = new ErrorDoc(docIdUUID, 'DDB_ERROR', docIdUUID, {}, {}, { "keys": keys }, { "keys": keys }, `Exception - ${ex}`);
            return new ParseDocumentResult(null, errorDoc, ParseDocumentResultStatus.ERROR);
        }
    }
}
