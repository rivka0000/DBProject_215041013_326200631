-- =========================
-- Rollback example
-- עדכון זמני של סטטוס נהג ואז ביטול השינוי
-- =========================

BEGIN;


-- עדכון זמני
UPDATE DRIVER
SET status = 'inactive'
WHERE licenseNumber = (
    SELECT licenseNumber
    FROM DRIVER
    ORDER BY licenseNumber
    LIMIT 1
);

-- מצב בסיס הנתונים אחרי העדכון
SELECT licenseNumber, fullName, phoneNumber, status
FROM DRIVER
ORDER BY licenseNumber
LIMIT 5;

-- ביטול השינוי
ROLLBACK;

-- מצב בסיס הנתונים אחרי rollback
-- כאן אמורים לראות שהסטטוס חזר למה שהיה בהתחלה
SELECT licenseNumber, fullName, phoneNumber, status
FROM DRIVER
ORDER BY licenseNumber
LIMIT 5;



-- =========================
-- Commit example - שינוי צבע לרכבי Toyota Corolla בלבד
-- =========================

-- התחלת טרנזקציה
BEGIN;

-- -------------------------
-- שלב 1: מצב לפני העדכון
-- מציגים רק רכבים מסוג Toyota Corolla
-- -------------------------
SELECT plateNumber, model, carColor
FROM VEHICLE
WHERE model = 'Toyota Corolla';


-- -------------------------
-- שלב 2: עדכון הנתונים
-- משנים צבע ל-Black רק לרכבים האלה
-- -------------------------
UPDATE VEHICLE
SET carColor = 'Black'
WHERE model = 'Toyota Corolla';


-- -------------------------
-- שלב 3: מצב אחרי העדכון (לפני COMMIT)
-- אמורים לראות שינוי בצבע
-- -------------------------
SELECT plateNumber, model, carColor
FROM VEHICLE
WHERE model = 'Toyota Corolla';


-- -------------------------
-- שלב 4: שמירת השינוי לצמיתות
-- -------------------------
COMMIT;


-- -------------------------
-- שלב 5: בדיקה אחרי COMMIT
-- הצבע אמור להישאר Black
-- -------------------------
SELECT plateNumber, model, carColor
FROM VEHICLE
WHERE model = 'Toyota Corolla';