const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('reports/{reportId}')
    .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    // Check if the report state has changed to reported
    if (newValue['currentState'] === 'reported' && previousValue['currentState'] !== 'reported') {
        const userId = newValue['userid'];
        const userDoc = await admin.firestore().collection('users').doc(userId).get();

        const userToken = userDoc.data()['fcmToken'];

        // Send notification to user
        try {
            await admin.messaging().send({
            token: userToken,
            notification: {
                title: 'Report Approved!',
                body: `Local Authorities received your ${newValue['type']} Report`,
            },
            });
            console.log('Notification sent successfully to user:', userId);
        } catch (error) {
            console.error('Error sending notification:', error);
        }
        
    }

    // Check if the report state has changed to fixed
    if (newValue['currentState'] === 'fixed' && previousValue['currentState'] !== 'fixed') {
        const userId = newValue['userid'];
        const userDoc = await admin.firestore().collection('users').doc(userId).get();

        // Send notification to user
        try {
            await admin.messaging().send({
            token: userToken,
            notification: {
                title: 'Report fixed!',
                body: `${newValue['type']} Report has been fixed, Thank You!`,
            },
            });
            console.log('Notification sent successfully to user:', userId);
        } catch (error) {
            console.error('Error sending notification:', error);
        }
        
    }
    });