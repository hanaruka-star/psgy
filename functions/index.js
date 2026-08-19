const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { setGlobalOptions } = require("firebase-functions/v2");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({ region: "asia-southeast1" });

const LOT_OPENED_TYPE = "lot_opened";
const WATCHLIST_CHANNEL = "watchlist_channel";

/**
 * Returns true when the parking lot was promoted from surveying_lots.
 */
async function isPromotedFromSurveying(db, lotId, lotData) {
  const metadata = lotData.metadata || {};

  if (
    metadata.source === "surveying_lot" ||
    metadata.promotedFrom === "surveying_lot" ||
    metadata.surveyingLotId
  ) {
    return true;
  }

  const surveyingSnap = await db.collection("surveying_lots").doc(lotId).get();
  return surveyingSnap.exists;
}

/**
 * Sends FCM topic notification when a surveying lot becomes an active parking lot.
 */
exports.notifyWatchlistOnLotOpen = onDocumentCreated(
  "parking_lots/{lotId}",
  async (event) => {
    const lotId = event.params.lotId;
    const lotData = event.data?.data();

    if (!lotData) {
      console.log(`parking_lots/${lotId}: empty document, skipping`);
      return null;
    }

    const db = admin.firestore();
    const fromSurveying = await isPromotedFromSurveying(db, lotId, lotData);

    if (!fromSurveying) {
      console.log(`parking_lots/${lotId}: not from surveying, skipping FCM`);
      return null;
    }

    const lotName = lotData.name || "Bãi xe";
    const topic = `lot_open_${lotId}`;

    const message = {
      topic,
      notification: {
        title: "Bãi bạn theo dõi đã mở cửa!",
        body: `${lotName} đã có chỗ đỗ • Nhấn để xem ngay`,
      },
      data: {
        type: LOT_OPENED_TYPE,
        lotId,
        lotName,
      },
      android: {
        priority: "high",
        notification: {
          channelId: WATCHLIST_CHANNEL,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log(`FCM sent to ${topic}: ${response}`);
      return response;
    } catch (error) {
      console.error(`FCM failed for ${topic}:`, error);
      throw error;
    }
  },
);
