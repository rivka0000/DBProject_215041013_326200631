/* =========================================
   DELETE QUERIES
   ========================================= */


/* 1. Delete cancelled rides
   מוחק נסיעות שבוטלו (Cancelled).
   מתאים לניקוי נסיעות שאינן רלוונטיות יותר למסך ניהול ההסעות.
   חשוב: הערך בטבלה הוא Cancelled עם אות גדולה. */
DELETE FROM RIDE
WHERE status = 'Cancelled';


/* 2. Delete old maintenance records for vehicles that are not active
   מוחק רשומות תחזוקה ישנות (מעל שנתיים),
   רק עבור רכבים שאינם פעילים כיום.
   המטרה היא לנקות מידע תחזוקה ישן שאינו רלוונטי לרכבים שאינם בשימוש,
   תוך שמירה על נתוני תחזוקה של רכבים פעילים.

   השאילתא משלבת בין MAINTENANCE ל-VEHICLE באמצעות EXISTS,
   ומשתמשת בתנאי על שדה התאריך maintenanceDate. */
DELETE FROM MAINTENANCE m
WHERE m.maintenanceDate < CURRENT_DATE - INTERVAL '2 years'
  AND EXISTS (
      SELECT 1
      FROM VEHICLE v
      WHERE v.plateNumber = m.plateNumber
        AND v.status <> 'Active'
  );


/* 3. Delete inactive drivers that were never assigned to any ride
   מוחק נהגים שאינם פעילים ואין להם אף נסיעה במערכת.
   מבחינה עסקית, נהגים כאלה אינם רלוונטיים למסך ניהול הנהגים.

   השאילתא משתמשת בתת־שאילתא עם NOT EXISTS כדי לוודא
   שלנהג אין אף נסיעה בטבלת RIDE. */
DELETE FROM DRIVER d
WHERE d.status <> 'Active'
  AND NOT EXISTS (
      SELECT 1
      FROM RIDE r
      WHERE r.licenseNumber = d.licenseNumber
  );