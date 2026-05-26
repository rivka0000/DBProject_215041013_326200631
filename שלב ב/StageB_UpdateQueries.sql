/* =========================================
   UPDATE QUERIES - Integrated Database
   ========================================= */


/* 1. Update vehicle status to 'Maintenance'
   מעדכן רכבים לסטטוס Maintenance אם עלות התחזוקה שלהם
   בשנה הנוכחית גבוהה מ-5000. */
UPDATE vehicle
SET status = 'Maintenance'
WHERE platenumber IN (
    SELECT m.platenumber
    FROM maintenance m
    WHERE EXTRACT(YEAR FROM m.maintenancedate) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY m.platenumber
    HAVING SUM(m.cost) > 5000
);


/* 2. Update drivers to 'Busy' if they have rides today
   מעדכן נהגים לסטטוס Busy אם יש להם נסיעה שמקושרת
   למופע סיור שמתקיים היום.

   במסד המשולב התאריך נמצא בטבלת tourinstance,
   ולא בטבלת ride. */
UPDATE driver
SET status = 'Busy'
WHERE licensenumber IN (
    SELECT r.licensenumber
    FROM ride r
    JOIN tourinstance ti
        ON r.t_i_id = ti.t_i_id
    WHERE ti.t_date = CURRENT_DATE
);


/* 3. Update ride status to 'Long Completed'
   מעדכן נסיעות שהסתיימו לסטטוס Long Completed
   אם המסלול שלהן ארוך מ-100 ק״מ.

   במסד המשולב שעת הסיום נמצאת בטבלת tourinstance,
   ולכן מחברים ride אל tourinstance לפי t_i_id. */
UPDATE ride
SET status = 'Long Completed'
WHERE status = 'Completed'
  AND EXISTS (
      SELECT 1
      FROM tourinstance ti
      WHERE ti.t_i_id = ride.t_i_id
        AND ti.end_time IS NOT NULL
  )
  AND EXISTS (
      SELECT 1
      FROM route ro
      WHERE ro.origin = ride.origin
        AND ro.destination = ride.destination
        AND ro.distancekm > 100
  );