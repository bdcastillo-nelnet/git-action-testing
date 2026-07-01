// Lambda handler: return all users from the DynamoDB user_table.
// CORS is handled by the Lambda Function URL config, so no headers here.

const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, ScanCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

const TABLE_NAME = process.env.TABLE_NAME || "user_table";

exports.handler = async () => {
  try {
    // Scan reads every item. Fine for a small/learning table; for large
    // tables you would paginate or use a Query against an index instead.
    const result = await ddb.send(new ScanCommand({ TableName: TABLE_NAME }));

    return {
      statusCode: 200,
      body: JSON.stringify({ users: result.Items ?? [] }),
    };
  } catch (err) {
    console.error("Failed to list users:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Could not list users" }),
    };
  }
};
