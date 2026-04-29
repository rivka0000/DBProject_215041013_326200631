/* =========================================
   DELETE QUERIES
   ========================================= */


/* 1. Delete old cancelled rides from previous years
   מוחק נסיעות שבוטלו ושייכות לשנים קודמות בלבד.
   מתאים לניקוי היסטוריה לא רלוונטית ממערכת ניהול ההסעות.
   יש כאן שימוש בפירוק תאריך לפי שנה. */
DELETE FROM RIDE
WHERE status = 'cancelled'
  AND EXTRACT(YEAR FROM orderDate) < EXTRACT(YEAR FROM CURRENT_DATE);


/* 2. Delete old maintenance records for vehicles that are currently active
   מוחק רשומות תחזוקה ישנות מאוד רק עבור רכבים שעדיין פעילים.
   כלומר משאירים במערכת מידע תחזוקה עדכני, אבל מנקים היסטוריה ישנה.
   השאילתה משתמשת ביותר מטבלה אחת: MAINTENANCE ו-VEHICLE. */
DELETE FROM MAINTENANCE m
WHERE EXTRACT(YEAR FROM m.maintenanceDate) < EXTRACT(YEAR FROM CURRENT_DATE) - 3
  AND EXISTS (
      SELECT 1
      FROM VEHICLE v
      WHERE v.plateNumber = m.plateNumber
        AND v.status = 'active'
  );


/* 3. Delete inactive drivers that were never assigned to any ride
   מוחק נהגים לא פעילים שאין להם אף נסיעה במערכת.
   זה הגיוני עסקית כי נהג בלי היסטוריית נסיעות וסטטוס inactive
   לא תורם למסכי הניהול של החברה.
   משתמשים בתת שאילתה כדי לבדוק שאין לו נסיעות בטבלת RIDE. */
DELETE FROM DRIVER d
WHERE d.status = 'inactive'
  AND NOT EXISTS (
      SELECT 1
      FROM RIDE r
      WHERE r.licenseNumber = d.licenseNumber
  );