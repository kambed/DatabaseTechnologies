db = db.getSiblingDB('database');

//Select all products
db.products.find()

//Select product by name
db.products.findOne({ name: 'Better React app' })

//Select products from department
db.products.find({
    department: 'Backend',
    components: {$in: ['Backend']}
})

//Select with more developed filters
db.productAudits.find({
    auditScore: {$lt: 3},
    productName: "Better AI Python API"
})

//Update product
db.products.updateOne({ name: 'Better React app' }, {
    $set: {
        description: "Even a better website"
    }
})

//Update all products
db.products.updateMany({ department: 'Backend' }, {
    $set: {
        components: ["Not backend"]
    }
})

//Delete one product
db.products.deleteOne({ name: 'Better AI Python API' })

//Average score in audits for backend department products
db.auditsWithAuditors.aggregate([
    {
        $match: { productDepartment: "Backend" }
    },
    {
        $group: {
            _id: "$productName",
            averageAuditScore: { $avg: "$auditScore" }
        }
    }
])