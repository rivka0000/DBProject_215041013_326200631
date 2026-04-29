/* =========================================
   UPDATE QUERIES
   ========================================= */


/* 1. Update vehicle status to 'maintenance' for vehicles with high maintenance cost this year
   מעדכן רכב לסטטוס maintenance אם בשנה הנוכחית עלות התחזוקה שלו גבוהה מ-5000.
   מתאים למסך Fleet & Maintenance במערכת.
   יש כאן שימוש בתאריך, GROUP BY ו-HAVING. */
UPDATE VEHICLE
SET status = 'maintenance'
WHERE plateNumber IN (
    SELECT m.plateNumber
    FROM MAINTENANCE m
    WHERE EXTRACT(YEAR FROM m.maintenanceDate) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY m.plateNumber
    HAVING SUM(m.Cost) > 5000
);


/* 2. Update drivers to 'busy' if they have active rides today
   מעדכן נהגים לסטטוס busy אם יש להם נסיעה פעילה היום.
   מתאים למסך הנהגים במערכת, כדי לראות מי תפוס כרגע.
   משתמשים בתאריך ומצליבים מידע בין DRIVER ל-RIDE. */
UPDATE DRIVER
SET status = 'busy'
WHERE licenseNumber IN (
    SELECT r.licenseNumber
    FROM RIDE r
    WHERE r.status IN ('active', 'in_progress')
      AND EXTRACT(YEAR FROM r.orderDate) = EXTRACT(YEAR FROM CURRENT_DATE)
      AND EXTRACT(MONTH FROM r.orderDate) = EXTRACT(MONTH FROM CURRENT_DATE)
      AND EXTRACT(DAY FROM r.orderDate) = EXTRACT(DAY FROM CURRENT_DATE)
);


/* 3. Update ride status to 'long_completed' for completed long-distance rides
   מעדכן נסיעות שהסתיימו לסטטוס long_completed אם המסלול שלהן ארוך מ-100 ק״מ.
   מתאים לדוחות של נסיעות ארוכות או נסיעות בין-עירוניות.
   השאילתה מחברת בין RIDE ל-ROUTE דרך origin ו-destination. */
UPDATE RIDE
SET status = 'long_completed'
WHERE endTime IS NOT NULL
  AND status = 'completed'
  AND EXISTS (
      SELECT 1
      FROM ROUTE ro
      WHERE ro.origin = RIDE.origin
        AND ro.destination = RIDE.destination
        AND ro.distanceKm > 100
  );