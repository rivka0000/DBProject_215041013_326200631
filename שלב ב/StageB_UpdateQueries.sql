/* =========================================
   UPDATE QUERIES
   ========================================= */


/* 1. Update vehicle status to 'Maintenance' for vehicles with high maintenance cost this year
   מעדכן רכב לסטטוס Maintenance אם בשנה הנוכחית עלות התחזוקה שלו גבוהה מ-5000.
   מתאים למסך Fleet & Maintenance במערכת.
   יש כאן שימוש בתאריך, GROUP BY ו-HAVING. */
UPDATE VEHICLE
SET status = 'Maintenance'
WHERE plateNumber IN (
    SELECT m.plateNumber
    FROM MAINTENANCE m
    WHERE EXTRACT(YEAR FROM m.maintenanceDate) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY m.plateNumber
    HAVING SUM(m.Cost) > 5000
);


/* 2. Update drivers to 'Busy' if they have rides today
   מעדכן נהגים לסטטוס Busy אם יש להם נסיעה היום.
   מתאים למסך הנהגים במערכת, כדי לראות מי משויך לנסיעות היום.
   משתמשים בפירוק תאריך ומצליבים מידע בין DRIVER ל-RIDE. */
UPDATE DRIVER
SET status = 'Busy'
WHERE licenseNumber IN (
    SELECT r.licenseNumber
    FROM RIDE r
    WHERE EXTRACT(YEAR FROM r.orderDate) = EXTRACT(YEAR FROM CURRENT_DATE)
      AND EXTRACT(MONTH FROM r.orderDate) = EXTRACT(MONTH FROM CURRENT_DATE)
      AND EXTRACT(DAY FROM r.orderDate) = EXTRACT(DAY FROM CURRENT_DATE)
);


/* 3. Update ride status to 'Long Completed' for completed long-distance rides
   מעדכן נסיעות שהסתיימו לסטטוס Long Completed אם המסלול שלהן ארוך מ-100 ק״מ.
   מתאים לדוחות של נסיעות ארוכות או נסיעות בין-עירוניות.
   השאילתא מחברת בין RIDE ל-ROUTE דרך origin ו-destination. */
UPDATE RIDE
SET status = 'Long Completed'
WHERE endTime IS NOT NULL
  AND status = 'Completed'
  AND EXISTS (
      SELECT 1
      FROM ROUTE ro
      WHERE ro.origin = RIDE.origin
        AND ro.destination = RIDE.destination
        AND ro.distanceKm > 100
  );