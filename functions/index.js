/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { logger } = require("firebase-functions");
const { onRequest, onCall } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

// The Firebase Admin SDK to access Firestore.
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const admin = require('firebase-admin');

initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into
// Firestore under the path /messages/:documentId/original
exports.addmessage = onRequest(async (req, res) => {
    try {
        // Grab the text parameter from query or body
        const original = req.query.text || req.body.text;
        if (!original) {
            res.status(400).send('Missing text parameter');
            return;
        }
        // Push the new message into Firestore using the Firebase Admin SDK.
        const writeResult = await getFirestore()
            .collection("messages")
            .add({ original: original });
        // Send back a message that we've successfully written the message
        res.json({ result: `Message with ID: ${writeResult.id} added.` });
    } catch (error) {
        logger.error("Error adding message:", error);
        res.status(500).send("Error adding message");
    }
});

// Listens for new messages added to /messages/:documentId/original
// and saves an uppercased version of the message
// to /messages/:documentId/uppercase
exports.makeuppercase = onDocumentCreated("/messages/{documentId}", async (event) => {
    try {
        const original = event.data.data().original;
        logger.log("Uppercasing", event.params.documentId, original);
        const uppercase = original.toUpperCase();
        await event.data.ref.set({ uppercase }, { merge: true });
    } catch (error) {
        logger.error("Error uppercasing message:", error);
    }
});


exports.sendNotification = onCall(async (data, context) => {
    try {
        const { userId, title, body } = data;
        if (!userId || !title || !body) {
            throw new functions.https.HttpsError('invalid-argument', 'Missing parameters');
        }

        const userDoc = await getFirestore().collection('users').doc(userId).get();
        if (!userDoc.exists) {
            throw new functions.https.HttpsError('not-found', 'User not found');
        }

        const fcmToken = userDoc.data().fcmToken;
        if (!fcmToken) {
            throw new functions.https.HttpsError('not-found', 'FCM token not found');
        }

        const message = {
            notification: {
                title: title,
                body: body
            },
            token: fcmToken
        };

        await admin.messaging().send(message);
        return { success: true };
    } catch (error) {
        logger.error("Error sending notification:", error);
        throw new functions.https.HttpsError('internal', 'Failed to send notification');
    }
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
