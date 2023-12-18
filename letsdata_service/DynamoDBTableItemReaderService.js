
import { logger } from "../letsdata_utils/logging_utils.js"
import { ServiceRequest, LetsDataAuthParams, InterfaceNames } from "./Service.js"
import { letsdata_assert } from "../letsdata_utils/validations.js";
import { DynamoDBTableItemReader } from "../letsdata_interfaces/readers/dynamodb/DynamoDBTableItemReader.js";
    
export class DynamoDBTableItemReaderService_ParseDynamoDBItem extends ServiceRequest {
    constructor(requestId, letsDataAuth, interfaceName, functionName, tableName, segmentNumber, keys, item) {
        super(requestId, letsDataAuth, interfaceName, functionName);
        this.tableName = tableName
        this.segmentNumber = segmentNumber
        this.keys = keys
        this.item = item
    }

    execute() {
        const parser = new DynamoDBTableItemReader();
        return  parser.parseDynamoDBItem(this.tableName, this.segmentNumber, this.keys, this.item);
    }
}

export function getDynamoDBTableItemReaderServiceRequest(requestId, letsDataAuth, interfaceName, functionName, data, batchedData) {
    letsdata_assert(interfaceName == InterfaceNames.DynamoDBTableItemReader, "invalid interfaceName - expected DynamoDBTableItemReader, got "+interfaceName.toString());
    letsdata_assert(letsDataAuth != undefined && letsDataAuth != null, "invalid letsDataAuth - None");
    const DynamoDBTableItemReaderInterfaceNames = new Set(["parseDynamoDBItem"]);    

    if (!DynamoDBTableItemReaderInterfaceNames.has(functionName)) {
        throw new Error("lambda event - invalid functionName "+functionName+" for interface DynamoDBTableItemReader");
    }
    
    if (functionName == "parseDynamoDBItem") {
        letsdata_assert(batchedData == undefined || batchedData == null || Object.keys(batchedData).length == 0, "invalid data - DynamoDBTableItemReader.parseDynamoDBItem requires empty batchedData dictionary");
        letsdata_assert(Object.keys(data).length == 3, "invalid data - DynamoDBTableItemReader.parseDynamoDBItem requires data keys [tableName,segmentNumber,data]");
        
        letsdata_assert(data.tableName != undefined && data.tableName != null, "invalid tableName - None - DynamoDBTableItemReader.parseDynamoDBItem requires data keys [tableName,segmentNumber,data]");
        letsdata_assert(data.tableName instanceof String || typeof data.tableName === 'string', "invalid tableName - DynamoDBTableItemReader.parseDynamoDBItem requires tableName value to be string");

        letsdata_assert(data.segmentNumber != undefined && data.segmentNumber != null, "invalid segmentNumber - None - DynamoDBTableItemReader.parseDynamoDBItem requires data keys [tableName,segmentNumber,data]");
        letsdata_assert(typeof(data.segmentNumber) == 'number' && Number.isInteger(data.segmentNumber), "invalid segmentNumber - DynamoDBTableItemReader.parseDynamoDBItem requires segmentNumber value to be int");

        letsdata_assert(data.data != undefined && data.data != null, "invalid data - None - DynamoDBTableItemReader.parseDynamoDBItem requires data keys [tableName,segmentNumber,data]");
        letsdata_assert(typeof data.data === 'object', "invalid messageAttributes - QueueMessageReader.parseMessage requires content value to be object");

        letsdata_assert(data.data.keys != undefined && data.data.keys != null, "invalid data.keys - None - DynamoDBTableItemReader.parseDynamoDBItem requires data.data keys [keys, item]");
        letsdata_assert(typeof data.data.keys === 'object', "invalid data.keys - DynamoDBTableItemReader.parseDynamoDBItem requires data.data.keys value to be object");

        letsdata_assert(data.data.item != undefined && data.data.item != null, "invalid data.item - None - DynamoDBTableItemReader.parseDynamoDBItem requires data.data.item keys [keys, item]");
        letsdata_assert(typeof data.data.item === 'object', "invalid data.item - DynamoDBTableItemReader.parseDynamoDBItem requires data.data.item value to be object");

        return new DynamoDBTableItemReaderService_ParseDynamoDBItem(requestId, letsDataAuth, interfaceName, functionName, data.tableName, data.segmentNumber, data.data.keys, data.data.item);
    } else {
        throw new Error("Unknown functionName");
    }
}
    