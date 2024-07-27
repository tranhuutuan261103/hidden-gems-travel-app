const { MongoClient, ObjectId } = require("mongodb");

const users = require("../extensions/users.json");
const categories = require("../extensions/categories.json");
const posts = require("../extensions/posts.json");
const comments = require("../extensions/comments.json");

// Function to transform the data
function transformData(data) {
    return data.map(entry => {
        if (entry._id && entry._id.$oid) {
            entry._id = new ObjectId(entry._id.$oid);
        }
        if (entry.createdBy && entry.createdBy.$oid) {
            entry.createdBy = new ObjectId(entry.createdBy.$oid);
        }
        if (entry.postId && entry.postId.$oid) {
            entry.postId = new ObjectId(entry.postId.$oid);
        }
        if (entry.star && entry.star.$numberInt) {
            entry.star = parseInt(entry.star.$numberInt);
        }
        if (entry.createdAt && entry.createdAt.$date && entry.createdAt.$date.$numberLong) {
            entry.createdAt = new Date(parseInt(entry.createdAt.$date.$numberLong));
        }
        if (entry.__v && entry.__v.$numberInt) {
            entry.__v = parseInt(entry.__v.$numberInt);
        }
        return entry;
    });
}

async function seedDB() {
    // Connection URL
    const uri = process.env.DATABASE_URL;

    const client = new MongoClient(uri, {
        monitorCommands: true,
    });

    try {
        await client.connect();
        console.log("Connected correctly to server");
        client.on('commandStarted', started => console.log(started));
        const db = client.db("test");

        // Transform data before inserting
        const transformedUsers = transformData(users);
        const transformedCategories = transformData(categories);
        const transformedPosts = transformData(posts);
        const transformedComments = transformData(comments);

        const collection_users = db.collection("users");
        await collection_users.insertMany(transformedUsers);

        const collection_categories = db.collection("categories");
        await collection_categories.insertMany(transformedCategories);

        const collection_posts = db.collection("posts");
        await collection_posts.insertMany(transformedPosts);

        const collection_comments = db.collection("comments");
        await collection_comments.insertMany(transformedComments);

        console.log("Database seeded! :)");
    } catch (err) {
        console.log(err.stack);
    } finally {
        client.close();
    }
}

module.exports = seedDB;