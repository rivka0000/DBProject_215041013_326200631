/* =========================================
   DELETE QUERIES - Integrated Database
   ========================================= */


/* 1. Delete cancelled rides
   מוחק נסיעות שבוטלו.
   מתאים לניקוי נסיעות שאינן רלוונטיות יותר למסך ניהול ההסעות. */
DELETE FROM ride
WHERE status = 'Cancelled';


/* 2. Delete old maintenance records for vehicles that are not active
   מוחק רשומות תחזוקה ישנות, מעל שנתיים,
   רק עבור רכבים שאינם פעילים כיום.

   השאילתא מחברת בין maintenance לבין vehicle
   לפי מספר הרכב platenumber. */
DELETE FROM maintenance m
WHERE m.maintenancedate < CURRENT_DATE - INTERVAL '2 years'
  AND EXISTS (
      SELECT 1
      FROM vehicle v
      WHERE v.platenumber = m.platenumber
        AND v.status <> 'Active'
  );


/* 3. Delete inactive drivers that were never assigned to any ride
   מוחק נהגים שאינם פעילים ואין להם אף נסיעה במערכת.

   השאילתא משתמשת ב-NOT EXISTS כדי לוודא
   שלא קיימת אף נסיעה בטבלת ride עבור אותו נהג. */
DELETE FROM driver d
WHERE d.status <> 'Active'
  AND NOT EXISTS (
      SELECT 1
      FROM ride r
      WHERE r.licensenumber = d.licensenumber
  );