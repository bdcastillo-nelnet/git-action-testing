// Lambda handler: create a new user in the DynamoDB user_table.
// Expects first_name and last_name; generates a user_id automatically.

const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");
const { randomUUID } = require("crypto");

// The SDK v3 clients are provided by the nodejs20.x Lambda runtime.
const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

const TABLE_NAME = process.env.TABLE_NAME || "user_table";

exports.handler = async (event) => {
  try {
    // Works whether invoked directly (event = {...}) or via API Gateway
    // (event.body is a JSON string).
    const input =
      typeof event.body === "string" ? JSON.parse(event.body) : event.body || event;

    const { first_name, last_name } = input;

    if (!first_name || !last_name) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "first_name and last_name are required" }),
      };
    }

    const user = {
      user_id: randomUUID(),
      first_name,
      last_name,
    };

    await ddb.send(
      new PutCommand({
        TableName: TABLE_NAME,
        Item: user,
      })
    );

    return {
      statusCode: 201,
      body: JSON.stringify(user),
    };
  } catch (err) {
    console.error("Failed to create user:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Could not create user" }),
    };
  }
};
