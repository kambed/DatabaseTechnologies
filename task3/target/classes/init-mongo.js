// Create a new MongoDB database
db = db.getSiblingDB('mydatabase');

// Create a new collection
db.createCollection('mycollection');

// Insert some documents into the collection
db.mycollection.insertMany([
    { name: 'Document 1', value: 10 },
    { name: 'Document 2', value: 20 },
    { name: 'Document 3', value: 30 }
]);

print('Initialization script ran successfully!');