const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const path = require("path");

exports.generateSoundInfo = functions.storage.object().onFinalize((object) => {
  const filePath = object.name;
  const fileName = path.basename(filePath);

  const doc = admin.firestore().doc(`/sounds/${fileName}`);

  doc.set({
    title: "",
    fileName: fileName,
    location: "",
    length: "",
    city: "",
    province: "",
    time: "",
  });
});
