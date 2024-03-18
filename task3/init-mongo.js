db = db.getSiblingDB('database');

db.createCollection('auditYearParts');
db.createCollection('productAudits');
db.createCollection('products');
db.createCollection('productTeamMembers');
db.createCollection('users');

db.auditYearParts.insertMany([
    { name: '2022H1', startDate: new Date("2022-02-01T00:00:00Z"), endDate: new Date("2022-02-07T00:00:00Z"), isClosed: true },
    { name: '2022H2', startDate: new Date("2022-08-22T00:00:00Z"), endDate: new Date("2022-08-25T00:00:00Z"), isClosed: true },
    { name: '2023H1', startDate: new Date("2023-04-05T00:00:00Z"), endDate: new Date("2023-04-06T00:00:00Z"), isClosed: true },
    { name: '2023H2', startDate: new Date("2023-12-10T00:00:00Z"), isClosed: false }
]);

db.products.insertMany([
    { name: 'Better mobile app', department: 'Mobile', description: 'A better mobile app', components: ['Frontend', 'Mobile']},
    { name: 'Better React app', department: 'Frontend', description: 'A better website', components: ['Frontend', 'Backend']},
    { name: 'Better Spring API', department: 'Backend', description: 'A better API', components: ['Backend']},
    { name: 'Better AI Python API', department: 'Backend', description: 'A better AI API', components: ['Backend']},
    { name: 'Better MySQL', department: 'Backend', description: 'A better database', components: ['Backend', 'Database']}
]);

db.users.insertMany([
    { nickname: 'ecoljohn', email: 'john.colors@gmail.com', firstName: 'John', lastName: 'Colors' },
    { nickname: 'ecarjan', email: 'jane.cargo200@gmail.com', firstName: 'Jane', lastName: 'Cargo' },
    { nickname: 'ekowemi', email: 'qwerty@wp.pl', firstName: 'Emil', lastName: 'Kowalski' }
]);

db.productTeamMembers.insertMany([
    { productName: 'Better mobile app', userNickname: 'ecoljohn', role: 'Developer' },
    { productName: 'Better Spring API', userNickname: 'ecoljohn', role: 'Developer' },
    { productName: 'Better mobile app', userNickname: 'ecarjan', role: 'Tester' },
    { productName: 'Better React app', userNickname: 'ekowemi', role: 'OPO' },
    { productName: 'Better React app', userNickname: 'ekowemi', role: 'Scrum master' },
    { productName: 'Better React app', userNickname: 'ekowemi', role: 'Developer' },
    { productName: 'Better React app', userNickname: 'ekowemi', role: 'Tester' }
]);

db.productAudits.insertMany([
    { productName: 'Better mobile app', auditYearPartName: '2022H1', auditDate: new Date("2022-02-01T00:00:00Z"), auditScore: 4, auditComment: 'Good job!', auditorNickname: 'ecoljohn' },
    { productName: 'Better mobile app', auditYearPartName: '2022H2', auditDate: new Date("2022-10-02T00:00:00Z"), auditScore: 5, auditComment: 'Great job!', auditorNickname: 'ecarjan' },
    { productName: 'Better React app', auditYearPartName: '2022H2', auditDate: new Date("2022-10-20T00:00:00Z"), auditScore: 3, auditComment: 'Wrong security!', auditorNickname: 'ecoljohn' },
    { productName: 'Better React app', auditYearPartName: '2023H1', auditDate: new Date("2023-04-05T00:00:00Z"), auditScore: 4, auditComment: 'Good job!', auditorNickname: 'ecoljohn' },
    { productName: 'Better React app', auditYearPartName: '2023H2', auditDate: new Date("2023-12-10T00:00:00Z"), auditScore: 5, auditComment: 'Great job!', auditorNickname: 'ecarjan' },
    { productName: 'Better Spring API', auditYearPartName: '2022H2', auditDate: new Date("2022-10-20T00:00:00Z"), auditScore: 2, auditComment: 'Not good!!!', auditorNickname: 'ecoljohn' },
    { productName: 'Better Spring API', auditYearPartName: '2023H2', auditDate: new Date("2023-12-09T00:00:00Z"), auditScore: 5, auditComment: 'Great job!', auditorNickname: 'ecarjan' },
    { productName: 'Better AI Python API', auditYearPartName: '2022H2', auditDate: new Date("2022-10-20T00:00:00Z"), auditScore: 1, auditComment: '???', auditorNickname: 'ecoljohn' },
]);

db.createView( "productWithTeam", "productTeamMembers", [
    {
        $lookup: {
            from: "products",
            localField: "productName",
            foreignField: "name",
            as: "productAndTeamMembers"
        },
    },
    {
        $unwind: "$productAndTeamMembers"
    },
    {
        $lookup: {
            from: "users",
            localField: "userNickname",
            foreignField: "nickname",
            as: "teamMembersAndUsers"
        }
    },
    {
        $unwind: "$teamMembersAndUsers"
    },
    {
        $project: {
           _id: 0,
           productName: 1,
           productDepartment: "$productAndTeamMembers.department",
           productDescription: "$productAndTeamMembers.description",
           userNickname: 1,
           userFirstname: "$teamMembersAndUsers.firstName",
           userLastname: "$teamMembersAndUsers.lastName",
           userEmail: "$teamMembersAndUsers.email",
           role: 1
        }
    }
])

db.createView( "auditsWithAuditors", "productAudits", [
    {
        $lookup: {
            from: "users",
            localField: "auditorNickname",
            foreignField: "nickname",
            as: "auditors"
        }
    },
    {
        $unwind: "$auditors"
    },
    {
        $lookup: {
            from: "products",
            localField: "productName",
            foreignField: "name",
            as: "productsDescriptions"
        }
    },
    {
        $unwind: "$productsDescriptions"
    },
    {
        $project: {
           _id: 0,
           productName: 1,
           productDepartment: "$productsDescriptions.department",
           auditYearPartName: 1,
           auditDate: 1,
           auditScore: 1,
           auditComment: 1,
           auditorNickname: 1,
           auditorFirstname: "$auditors.firstName",
           auditorLastname: "$auditors.lastName",
           auditorEmail: "$auditors.email"
        }
    }
])

