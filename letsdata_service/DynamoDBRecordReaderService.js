
import { logger } from "../letsdata_utils/logging_utils.js"
import { ServiceRequest, LetsDataAuthParams, InterfaceNames } from "./Service.js"
import { letsdata_assert } from "../letsdata_utils/validations.js";
import { DynamoDBStreamsRecordReader } from "../letsdata_interfaces/readers/dynamodbstreams/DynamoDBStreamsRecordReader.js";
    
export class DynamoDBRecordReaderService_ParseMessage extends ServiceRequest {
    constructor(requestId, letsDataAuth, interfaceName, functionName, streamArn, shardId, eventId, eventName, identityPrincipalId, identityType, sequenceNumber, sizeBytes, streamViewType, approximateCreationDateTime, keys, oldImage, newImage) {
        super(requestId, letsDataAuth, interfaceName, functionName);
        this.streamArn = streamArn
        this.shardId = shardId
        this.eventId = eventId
        this.eventName = eventName
        this.identityPrincipalId = identityPrincipalId
        this.identityType = identityType
        this.sequenceNumber = sequenceNumber
        this.sizeBytes = sizeBytes
        this.streamViewType = streamViewType
        this.approximateCreationDateTime = approximateCreationDateTime
        this.keys = keys
        this.oldImage = oldImage
        this.newImage = newImage
    }

    execute() {
        const parser = new DynamoDBStreamsRecordReader();
        return  parser.parseRecord(this.streamArn, this.shardId, this.eventId, this.eventName, this.identityPrincipalId, this.identityType, this.sequenceNumber, this.sizeBytes, this.streamViewType, this.approximateCreationDateTime, this.keys, this.oldImage, this.newImage);
    }
}

export function getDynamoDBRecordReaderServiceRequest(requestId, letsDataAuth, interfaceName, functionName, data, batchedData) {
    letsdata_assert(interfaceName == InterfaceNames.DynamoDBStreamsRecordReader, "invalid interfaceName - expected DynamoDBStreamsRecordReader, got "+interfaceName.toString());
    letsdata_assert(letsDataAuth != undefined && letsDataAuth != null, "invalid letsDataAuth - None");
    const DynamoDBStreamsRecordReaderInterfaceNames = new Set(["parseRecord"]);    

    if (!DynamoDBStreamsRecordReaderInterfaceNames.has(functionName)) {
        throw new Error("lambda event - invalid functionName "+functionName+" for interface DynamoDBStreamsRecordReader");
    }
    
    if (functionName == "parseRecord") {
        letsdata_assert(batchedData == undefined || batchedData == null || Object.keys(batchedData).length == 0, "invalid data - DynamoDBStreamsRecordReader.parseRecord requires empty batchedData dictionary");
        letsdata_assert(Object.keys(data).length == 11, "invalid data - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        
        letsdata_assert(data.streamArn != undefined && data.streamArn != null, "invalid messageId - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.streamArn instanceof String || typeof data.streamArn === 'string', "invalid streamArn - DynamoDBStreamsRecordReader.parseRecord requires streamArn value to be string");

        letsdata_assert(data.shardId != undefined && data.shardId != null, "invalid shardId - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.shardId instanceof String || typeof data.shardId === 'string', "invalid shardId - DynamoDBStreamsRecordReader.parseRecord requires shardId value to be string");

        letsdata_assert(data.eventId != undefined && data.eventId != null, "invalid eventId - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.eventId instanceof String || typeof data.eventId === 'string', "invalid eventId - DynamoDBStreamsRecordReader.parseRecord requires eventId value to be string");

        letsdata_assert(data.eventName != undefined && data.eventName != null, "invalid eventName - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.eventName instanceof String || typeof data.eventName === 'string', "invalid eventName - DynamoDBStreamsRecordReader.parseRecord requires eventName value to be string");

        if (data.identityPrincipalId != undefined && data.identityPrincipalId != null) {
            letsdata_assert(data.identityPrincipalId instanceof String || typeof data.identityPrincipalId === 'string', "invalid identityPrincipalId - DynamoDBStreamsRecordReader.parseRecord requires identityPrincipalId value to be string");
        }

        if (data.identityType != undefined && data.identityType != null) {
            letsdata_assert(data.identityType instanceof String || typeof data.identityType === 'string', "invalid identityType - DynamoDBStreamsRecordReader.parseRecord requires identityType value to be string");
        }

        letsdata_assert(data.sequenceNumber != undefined && data.sequenceNumber != null, "invalid sequenceNumber - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.sequenceNumber instanceof String || typeof data.sequenceNumber === 'string', "invalid sequenceNumber - DynamoDBStreamsRecordReader.parseRecord requires sequenceNumber value to be string");

        letsdata_assert(data.sizeBytes != undefined && data.sizeBytes != null, "invalid sizeBytes - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(typeof(data.sizeBytes) == 'number' && Number.isInteger(data.sizeBytes), "invalid sizeBytes - DynamoDBStreamsRecordReader.parseRecord requires sizeBytes value to be int");

        letsdata_assert(data.approximateCreationDateTime != undefined && data.approximateCreationDateTime != null, "invalid approximateCreationDateTime - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(typeof(data.approximateCreationDateTime) == 'number' && Number.isInteger(data.approximateCreationDateTime), "invalid approximateCreationDateTime - DynamoDBStreamsRecordReader.parseRecord requires approximateCreationDateTime value to be int");

        letsdata_assert(data.sequenceNumber != undefined && data.sequenceNumber != null, "invalid sequenceNumber - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.sequenceNumber instanceof String || typeof data.sequenceNumber === 'string', "invalid sequenceNumber - DynamoDBStreamsRecordReader.parseRecord requires sequenceNumber value to be string");

        letsdata_assert(data.streamViewType != undefined && data.streamViewType != null, "invalid streamViewType - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.streamViewType instanceof String || typeof data.streamViewType === 'string', "invalid streamViewType - DynamoDBStreamsRecordReader.parseRecord requires streamViewType value to be string");

        letsdata_assert(data.streamViewType != undefined && data.streamViewType != null, "invalid streamViewType - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(data.streamViewType instanceof String || typeof data.streamViewType === 'string', "invalid streamViewType - DynamoDBStreamsRecordReader.parseRecord requires streamViewType value to be string");

        letsdata_assert(data.data != undefined && data.data != null, "invalid data - None - DynamoDBStreamsRecordReader.parseRecord requires data keys [streamArn,shardId,eventId,eventName,identityPrincipalId,identityType,sequenceNumber,sizeBytes,streamViewType,approximateCreationDateTime,data]");
        letsdata_assert(typeof data.data === 'object', "invalid messageAttributes - QueueMessageReader.parseMessage requires content value to be object");

        letsdata_assert(data.data.keys != undefined && data.data.keys != null, "invalid data.keys - None - DynamoDBStreamsRecordReader.parseRecord requires data.data keys [keys, oldImage, newImage]");
        letsdata_assert(typeof data.data.keys === 'object', "invalid data.keys - DynamoDBStreamsRecordReader.parseRecord requires data.data.keys value to be object");

        letsdata_assert(data.data.oldImage != undefined && data.data.oldImage != null, "invalid data.oldImage - None - DynamoDBStreamsRecordReader.parseRecord requires data.data.oldImage keys [keys, oldImage, newImage]");
        letsdata_assert(typeof data.data.oldImage === 'object', "invalid data.oldImage - DynamoDBStreamsRecordReader.parseRecord requires data.data.oldImage value to be object");

        letsdata_assert(data.data.newImage != undefined && data.data.newImage != null, "invalid data.newImage - None - DynamoDBStreamsRecordReader.parseRecord requires data.data.newImage keys [keys, oldImage, newImage]");
        letsdata_assert(typeof data.data.newImage === 'object', "invalid data.newImage - DynamoDBStreamsRecordReader.parseRecord requires data.data.newImage value to be object");

        return new DynamoDBRecordReaderService_ParseMessage(requestId, letsDataAuth, interfaceName, functionName, data.streamArn, data.shardId, data.eventId, data.eventName, data.identityPrincipalId, data.identityType, data.sequenceNumber,data.sizeBytes,data.streamViewType,data.approximateCreationDateTime,data.data.keys,data.data.oldImage,data.data.newImage);
    } else {
        throw new Error("Unknown functionName");
    }
}
    