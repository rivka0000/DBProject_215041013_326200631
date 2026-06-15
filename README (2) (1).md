# TransRoute - Transportation Management System

**Course:** Databases | Mini-Project  

**Submitted by:** 
* Rivka Azrad (ID: 215041013)  
* Tirtsa Abuhatsira (ID: 326200631)


## Selected Module
Transportation Company Management

## Table of Contents

## שלב א' - עיצוב , בניה ואכלוס נתונים וגיבוי
1. [Project Overview](#transroute---transportation-management-system)
2. [Selected Module](#selected-module)
3. [System Description](#system-description-transroute-tms)
4. [Main Sections](#main-sections)
5. [Key Features](#key-features)
6. [System Diagrams](#system-diagrams)
7. [Data Insertion Methods](#data-insertion-methods)
8. [Backup](#backup)
9. [Screenshots](#screenshots)
10. [Access Link](#access-link)

## שלב ב׳ - שאילתות SELECT מורכבות
1. [שלב ב׳ - שאילתות SELECT מורכבות](#phase-2)
2. [שאילתות SELECT כפולות](#שאילתות-select-כפולות)
3. [4 שאילתות SELECT נוספות](#4-שאילתות-select-נוספות)
4. [שאילתות DELETE](#שאילתות-delete)
5. [שאילתות UPDATE](#שאילתות-update)
6. [Rollback ו-Commit](#rollback-ו-commit)
7. [אילוצים](#אילוצים)
8. [אינדקסים](#אינדקסים)

## שלב ג
1. [שלב ג](#phase-3)
2. [החלטות שנעשו בשלב האינטגרציה](#integration-decisions)
3. [הסבר מילולי של התהליך והפקודות](#process-explanation)
4. [מבט 1: driver_rides_view](#view-1)
5. [מבט 2: approved_bookings_view](#view-2)

## שלב ד - תכנות
1. [שלב ד - תכנות](#שלב-ד---תכנות)
2. [תיאור מילולי – תוכנית ראשית א](#תיאור-מילולי--תוכנית-ראשית-א)
3. [קוד התוכנית – תוכנית ראשית א](#קוד-התוכנית--תוכנית-ראשית-א)
4. [פלט הרצת התוכנית – תוכנית ראשית א](#פלט-הרצת-התוכנית--תוכנית-ראשית-א)
5. [תיאור מילולי – תוכנית ראשית ב](#תיאור-מילולי--תוכנית-ראשית-ב)
6. [קוד התוכנית – תוכנית ראשית ב](#קוד-התוכנית--תוכנית-ראשית-ב)
7. [פלט הרצת התוכנית – תוכנית ראשית ב](#פלט-הרצת-התוכנית--תוכנית-ראשית-ב)
# Phase 1: System Foundation & UI Mockups

## System Description (TransRoute TMS)

The system is a transportation management system called TransRoute. Its main goal is to manage all the company’s operations in one place, including rides, drivers, vehicles, and customers.

When entering the system, there is a login screen that allows only authorized users to access it. After logging in, the user reaches the Dashboard, which shows an overview of the system. It includes information such as active rides, available drivers, active vehicles, and total revenue. There are also graphs and live status updates that show real-time activity.

## Main Sections

The system is divided into several main sections:
	•	Ride Management – In this section, the user can view all rides, including customer details, route, date, price, and status. It is also possible to create a new ride, update its status (start, complete, cancel), and search for rides.
	•	Customers – This section allows adding new customers and viewing their details such as name, email, and phone number.
	•	Drivers – Here the user can add drivers, view their details, and track their availability (available or off duty).
	•	Fleet & Maintenance – This section shows all vehicles with details like model, year, and capacity. It also shows whether a vehicle is active or under maintenance, and allows adding maintenance records.

## Key Features

One of the main features of the system is scheduling a new ride. In this process, the user selects a customer, driver, and vehicle, and defines the origin, destination, date, and time. The system also calculates an estimated price for the ride.

In addition, the system allows easy data entry through simple forms, management of existing data, and tracking of the company’s activity in a clear and organized way.
Overall, the system is designed to help manage transportation operations efficiently, in a simple and user-friendly way.




## System Diagrams

Erd diagram:

<img width="5025" height="2028" alt="erdplus (3)" src="https://github.com/user-attachments/assets/d589a425-6fc0-4c3a-b97b-5d893f5d2405" />

Dsd diagram:
<img width="5025" height="2028" alt="erdplus (4)" src="https://github.com/user-attachments/assets/c83b6b14-a570-4da0-8d68-eae81b18bf88" />

## Data Insertion Methods

first method:

![WhatsApp Image 2026-04-14 at 11 37 14](https://github.com/user-attachments/assets/e9db0304-60f8-49ad-b02d-546f2acf2fcd)
![WhatsApp Image 2026-04-14 at 11 37 14 (1)](https://github.com/user-attachments/assets/8f774ec8-2a16-4105-8f0d-8df5a1a1add6)

second method:

![WhatsApp Image 2026-04-14 at 11 37 14 (1)](https://github.com/user-attachments/assets/d3fb1ce3-e3cc-4816-bbeb-74b85f03bb55)
![WhatsApp Image 2026-04-14 at 11 37 14](https://github.com/user-attachments/assets/3e6c4387-6da3-4677-8c58-459d6c759bf8)

third method (python scrypt):

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/be55aba6-9bee-41c1-ae56-6765ecaec944" />

## Backup

<img width="1920" height="1080" alt="‏‏צילום מסך (362)" src="https://github.com/user-attachments/assets/c8f77d9a-d10b-4d80-b19b-754d82aadc96" />
<img width="1920" height="1080" alt="‏‏צילום מסך (363)" src="https://github.com/user-attachments/assets/93cf85a4-5fe8-4cf3-83f2-533428341235" />

<img width="1920" height="1080" alt="‏‏צילום מסך (366)" src="https://github.com/user-attachments/assets/b83a24cb-9232-4111-b357-7a2dfd1d1f3c" />
<img width="1920" height="1080" alt="‏‏צילום מסך (365)" src="https://github.com/user-attachments/assets/5de038b4-7f31-4056-a38c-7a5612cbfbdb" />


## Screenshots

<img width="1920" height="1080" alt="‏‏צילום מסך (257)" src="https://github.com/user-attachments/assets/e1af9543-db1b-4421-8a0a-864d84360c16" /># 
<img width="1920" height="1080" alt="‏‏צילום מסך (270)" src="https://github.com/user-attachments/assets/2f87eb89-8727-4c1d-a066-748313c17bbc" />
<img width="1920" height="1080" alt="‏‏צילום מסך (269)" src="https://github.com/user-attachments/assets/c8214bd7-e3c8-4855-a173-4e6f7c1f38a4" />
<img width="1920" height="1080" alt="‏‏צילום מסך (268)" src="https://github.com/user-attachments/assets/712f417b-cca3-4b0e-8dae-96326b7a01b9" />
<img width="1920" height="1080" alt="‏‏צילום מסך (267)" src="https://github.com/user-attachments/assets/5c60a76a-ab27-4d5c-9362-08cd20adce44" />
<img width="1920" height="1080" alt="‏‏צילום מסך (266)" src="https://github.com/user-attachments/assets/c7218ffb-343f-410c-8a93-7c4068ecabcf" />
<img width="1920" height="1080" alt="‏‏צילום מסך (265)" src="https://github.com/user-attachments/assets/785cf5f5-d616-434c-88f9-ac8688d5b4dd" />
<img width="1920" height="1080" alt="‏‏צילום מסך (264)" src="https://github.com/user-attachments/assets/c5f14a35-9e28-41a0-8f0e-77af26883e67" />
<img width="1920" height="1080" alt="‏‏צילום מסך (257)" src="https://github.com/user-attachments/assets/21fec4eb-a197-4ad4-bcf3-321d8f54716b" />
<img width="1920" height="1080" alt="‏‏צילום מסך (284)" src="https://github.com/user-attachments/assets/6917f0e4-b3cc-41f8-be76-35916063adb6" />
<img width="1920" height="1080" alt="‏‏צילום מסך (283)" src="https://github.com/user-attachments/assets/a4f24506-abf1-4712-83ac-0b4e4764049c" />
<img width="1920" height="1080" alt="‏‏צילום מסך (279)" src="https://github.com/user-attachments/assets/e0a85b05-5a1d-4fa2-9291-f8dba5e8831c" />
<img width="1920" height="1080" alt="‏‏צילום מסך (277)" src="https://github.com/user-attachments/assets/c7924509-a162-4c2a-86ee-4d3adc4e6af1" />
<img width="1920" height="1080" alt="‏‏צילום מסך (276)" src="https://github.com/user-attachments/assets/27a683cc-6683-48ff-a1f8-32ed40f9b296" />
<img width="1920" height="1080" alt="‏‏צילום מסך (275)" src="https://github.com/user-attachments/assets/0b9ce4c9-a2fd-4085-b72e-29c9df25e244" />
<img width="1920" height="1080" alt="‏‏צילום מסך (274)" src="https://github.com/user-attachments/assets/9e2d6563-305c-484b-aeab-124fd939c64c" />
<img width="1920" height="1080" alt="‏‏צילום מסך (273)" src="https://github.com/user-attachments/assets/ddd2028a-b560-4b03-9ea2-b0db2496d712" />
<img width="1920" height="1080" alt="‏‏צילום מסך (272)" src="https://github.com/user-attachments/assets/f0af98b5-5b4a-4c6d-9077-edb991537682" />
<img width="1920" height="1080" alt="‏‏צילום מסך (271)" src="https://github.com/user-attachments/assets/a1ea8abe-286e-4b95-a150-cd114949ae50" />


## Access Link

Link to the AI Studio website:  https://ai.studio/apps/9c49efd4-73ff-40a2-84b3-add04e22e127?fullscreenApplet=true


## <a id="phase-2"></a>שלב ב׳ - שאילתות SELECT מורכבות

## שאילתות SELECT כפולות

**1. Ride Management – הצגת פרטי נסיעות מלאים**

**תיאור השאילתא:**
שאילתא זו מיועדת למסך ניהול הנסיעות במערכת.
היא מציגה את כל פרטי הנסיעה כולל פרטי לקוח, נהג, רכב ומסלול.
המידע שימושי למנהל המערכת כדי לראות במקום אחד את כל פרטי הנסיעות.


**צורה א׳ — שימוש ב־JOIN:**

```sql

SELECT 
    R.rideId,
    R.orderDate,
    R.startTime,
    R.endTime,
    R.status AS rideStatus,
    R.paymentMethod,
    C.id AS customerId,
    C.fullName AS customerName,
    C.phoneNumber AS customerPhone,
    D.licenseNumber,
    D.fullName AS driverName,
    D.phoneNumber AS driverPhone,
    V.plateNumber,
    V.model AS vehicleModel,
    V.carColor,
    V.status AS vehicleStatus,
    RT.origin,
    RT.destination,
    RT.distanceKm,
    RT.estimatedTravelTime
FROM RIDE R
JOIN CUSTOMER C ON R.id = C.id
JOIN DRIVER D ON R.licenseNumber = D.licenseNumber
JOIN VEHICLE V ON R.plateNumber = V.plateNumber
JOIN ROUTE RT ON R.origin = RT.origin AND R.destination = RT.destination
ORDER BY R.orderDate DESC, R.startTime DESC;
```

**צורה ב׳ — שימוש בתתי־שאילתות**

```sql

SELECT 
    R.rideId,
    R.orderDate,
    R.startTime,
    R.endTime,
    R.status AS rideStatus,
    R.paymentMethod,
    R.id AS customerId,
    (SELECT C.fullName FROM CUSTOMER C WHERE C.id = R.id) AS customerName,
    (SELECT C.phoneNumber FROM CUSTOMER C WHERE C.id = R.id) AS customerPhone,
    R.licenseNumber,
    (SELECT D.fullName FROM DRIVER D WHERE D.licenseNumber = R.licenseNumber) AS driverName,
    (SELECT D.phoneNumber FROM DRIVER D WHERE D.licenseNumber = R.licenseNumber) AS driverPhone,
    R.plateNumber,
    (SELECT V.model FROM VEHICLE V WHERE V.plateNumber = R.plateNumber) AS vehicleModel,
    (SELECT V.carColor FROM VEHICLE V WHERE V.plateNumber = R.plateNumber) AS carColor,
    (SELECT V.status FROM VEHICLE V WHERE V.plateNumber = R.plateNumber) AS vehicleStatus,
    R.origin,
    R.destination,
    (SELECT RT.distanceKm
     FROM ROUTE RT
     WHERE RT.origin = R.origin AND RT.destination = R.destination) AS distanceKm,
    (SELECT RT.estimatedTravelTime
     FROM ROUTE RT
     WHERE RT.origin = R.origin AND RT.destination = R.destination) AS estimatedTravelTime
FROM RIDE R
ORDER BY R.orderDate DESC, R.startTime DESC;

```

**צילום הרצה**


<img width="1641" height="945" alt="image" src="https://github.com/user-attachments/assets/4e1a576a-4ef1-4271-b877-d0bebf24541a" />
<img width="848" height="322" alt="image" src="https://github.com/user-attachments/assets/cc49b022-9e8d-40de-8555-9b68da939bd4" />

**צילום תוצאה**

<img width="1146" height="239" alt="image" src="https://github.com/user-attachments/assets/7b3057c5-5e3d-4acc-80e2-2c65dc562bdb" />
<img width="1148" height="332" alt="image" src="https://github.com/user-attachments/assets/d33e73a1-0016-4974-8dab-dd1261d8f67d" />




**הסבר יעילות**

שתי השאילתות מחזירות את אותו מידע, אך הצורה הראשונה עם JOIN יעילה יותר.
ב־JOIN בסיס הנתונים מבצע חיבור מסודר בין הטבלאות ויכול להשתמש טוב יותר באינדקסים ובמפתחות הזרים.
לעומת זאת, בצורת תתי־השאילתות, עבור כל שורה בטבלת RIDE מתבצעות שאילתות נוספות כדי להביא את שם הלקוח, הנהג, הרכב והמסלול. לכן כאשר יש הרבה נסיעות, השיטה הזו עלולה להיות איטית יותר.
לכן במקרה זה השימוש ב־JOIN עדיף.




**2. Driver Dashboard – הנהגים שביצעו הכי הרבה נסיעות**


**תיאור השאילתא**

שאילתא זו מיועדת למסך הנהגים או למסך הדשבורד.
היא מציגה את הנהגים שביצעו הכי הרבה נסיעות בשנת 2025.
המידע עוזר למנהל לבדוק מי הנהגים הפעילים ביותר במערכת.

**צורה א׳ — GROUP BY ו־ORDER BY**

``` sql

SELECT 
    D.licenseNumber,
    D.fullName,
    D.phoneNumber,
    D.status,
    COUNT(R.rideId) AS totalRides
FROM DRIVER D
JOIN RIDE R ON D.licenseNumber = R.licenseNumber
WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
GROUP BY D.licenseNumber, D.fullName, D.phoneNumber, D.status
ORDER BY totalRides DESC;
```

**צורה ב׳ — תת־שאילתא (Subquery)**

``` sql

SELECT 
    D.licenseNumber,
    D.fullName,
    D.phoneNumber,
    D.status,
    DriverCounts.totalRides
FROM DRIVER D
JOIN (
    SELECT 
        R.licenseNumber,
        COUNT(R.rideId) AS totalRides
    FROM RIDE R
    WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
    GROUP BY R.licenseNumber
) AS DriverCounts
ON D.licenseNumber = DriverCounts.licenseNumber
ORDER BY DriverCounts.totalRides DESC;

``` 

**צילום הרצה**


<img width="1600" height="900" alt="image" src="https://github.com/user-attachments/assets/1fd122a8-8d2f-4b07-a87c-00956723147a" />
<img width="1915" height="996" alt="image" src="https://github.com/user-attachments/assets/163917b2-7fae-4003-9f87-3569167e4f0d" />



**צילום תוצאה**


<img width="1600" height="900" alt="image" src="https://github.com/user-attachments/assets/d1cbc16b-c6a5-4ffc-a45c-4630bffc99dc" />
<img width="1870" height="800" alt="image" src="https://github.com/user-attachments/assets/474e1583-d037-48e0-a0fa-b1f3cde47050" />


**הסבר יעילות**

הצורה הראשונה מחשבת את מספר הנסיעות של כל נהג ישירות בעזרת JOIN בין טבלת DRIVER לטבלת RIDE, ולאחר מכן מבצעת GROUP BY לפי פרטי הנהג.

הצורה השנייה קודם מחשבת בתוך תת־שאילתא את מספר הנסיעות לכל נהג מתוך טבלת RIDE, ורק לאחר מכן מחברת את התוצאה לטבלת DRIVER כדי להציג את פרטי הנהג.

שתי הצורות מחזירות את אותה תוצאה: כל הנהגים שביצעו נסיעות בשנת 2025, יחד עם מספר הנסיעות שלהם, מסודרים מהגבוה לנמוך.

מבחינת יעילות, הצורה הראשונה בדרך כלל פשוטה ויעילה יותר, כי היא מבצעת את החיבור והחישוב בשאילתא אחת ישירה. הצורה השנייה יוצרת תוצאת ביניים בעזרת תת־שאילתא ורק לאחר מכן מבצעת חיבור נוסף, ולכן היא עשויה להיות פחות יעילה במסד נתונים גדול.

לכן להצגת דירוג נהגים במסך Dashboard, צורה א׳ עדיפה. צורה ב׳ מתאימה כדי להדגים שימוש בתת־שאילתא.

**3. Customer Analytics – הלקוחות שביצעו הכי הרבה הזמנות**



**תיאור השאילתא**

שאילתא זו מיועדת למסך הלקוחות או למסך ניתוח נתונים.
היא מציגה את הלקוחות שביצעו הכי הרבה נסיעות בחודש מסוים בשנת 2025.
המידע יכול לעזור למערכת לזהות לקוחות פעילים במיוחד.

**צורה א׳ — GROUP BY ו־ORDER BY**

``` sql

SELECT 
    C.id,
    C.fullName,
    C.phoneNumber,
    C.email,
    COUNT(R.rideId) AS totalRides
FROM CUSTOMER C
JOIN RIDE R ON C.id = R.id
WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
  AND EXTRACT

  ``` 

**צורה ב׳ — תת־שאילתא (Subquery)**

``` sql

SELECT 
    C.id,
    C.fullName,
    C.phoneNumber,
    C.email,
    CustomerCounts.totalRides
FROM CUSTOMER C
JOIN (
    SELECT 
        R.id,
        COUNT(R.rideId) AS totalRides
    FROM RIDE R
    WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
      AND EXTRACT(MONTH FROM R.orderDate) = 6
    GROUP BY R.id
) AS CustomerCounts
ON C.id = CustomerCounts.id
ORDER BY CustomerCounts.totalRides DESC, C.id;  

``` 

**צילום הרצה**


<img width="656" height="203" alt="image" src="https://github.com/user-attachments/assets/a3cf42cd-5389-40a5-a0ac-1fcb95d7f584" />
<img width="609" height="118" alt="image" src="https://github.com/user-attachments/assets/5728204b-43aa-4ad6-baae-f80efc838fd2" />

**צילום תוצאה**


<img width="961" height="267" alt="image" src="https://github.com/user-attachments/assets/4927ebbe-3737-48a9-a8d1-af6a27771e57" />
<img width="974" height="224" alt="image" src="https://github.com/user-attachments/assets/896c6ac0-9c86-4b36-b82a-a23778924edd" />

**הסבר הבדל ויעילות**

הצורה הראשונה מחשבת את מספר הנסיעות של כל נהג ישירות בעזרת JOIN בין טבלת DRIVER לטבלת RIDE, ולאחר מכן מבצעת GROUP BY לפי פרטי הנהג.

הצורה השנייה קודם מחשבת בתוך תת־שאילתא את מספר הנסיעות לכל נהג מתוך טבלת RIDE, ורק לאחר מכן מחברת את התוצאה לטבלת DRIVER כדי להציג את פרטי הנהג.

שתי הצורות מחזירות את אותה תוצאה: כל הנהגים שביצעו נסיעות בשנת 2025, יחד עם מספר הנסיעות שלהם, מסודרים מהגבוה לנמוך.

מבחינת יעילות, הצורה הראשונה בדרך כלל פשוטה ויעילה יותר, כי היא מבצעת את החיבור והחישוב בשאילתא אחת ישירה. הצורה השנייה יוצרת תוצאת ביניים בעזרת תת־שאילתא ורק לאחר מכן מבצעת חיבור נוסף, ולכן היא עשויה להיות פחות יעילה במסד נתונים גדול.

לכן להצגת דירוג נהגים במסך Dashboard, צורה א׳ עדיפה. צורה ב׳ מתאימה כדי להדגים שימוש בתת־שאילתא.


**4. Vehicle Management — רכבים שלא שובצו לנסיעות**


**תיאור השאילתא**

שאילתא זו מיועדת למסך ניהול רכבים.
היא מציגה רכבים שלא שובצו לאף נסיעה בשנת 2025.
המידע חשוב למנהל כדי לדעת אילו רכבים אינם מנוצלים.

**צורה א׳ — NOT IN**

``` sql

SELECT 
    V.plateNumber,
    V.model,
    V.capacity,
    V.carColor,
    V.year,
    V.status
FROM VEHICLE V
WHERE V.plateNumber NOT IN (
    SELECT R.plateNumber
    FROM RIDE R
    WHERE EXTRACT(YEAR FROM R.orderDate) = 2025
)
ORDER BY V.model, V.plateNumber;

``` 

**צורה ב׳ — NOT EXISTS**

``` sql

SELECT 
    V.plateNumber,
    V.model,
    V.capacity,
    V.carColor,
    V.year,
    V.status
FROM VEHICLE V
WHERE NOT EXISTS (
    SELECT 1
    FROM RIDE R
    WHERE R.plateNumber = V.plateNumber
      AND EXTRACT(YEAR FROM R.orderDate) = 2025
)
ORDER BY V.model, V.plateNumber;
``` 

**צילום הרצה**

<img width="1164" height="825" alt="image" src="https://github.com/user-attachments/assets/b6776bd3-b139-4be4-8102-cc308e160fd0" />
<img width="1224" height="796" alt="image" src="https://github.com/user-attachments/assets/af608c15-ee8b-4b91-972f-112adaf3cd71" />

**צילום תוצאה**


<img width="1180" height="688" alt="image" src="https://github.com/user-attachments/assets/1a7a465f-8bd6-4179-b0cc-e2c5056f4032" />
<img width="1020" height="217" alt="image" src="https://github.com/user-attachments/assets/21d46f4f-43c6-4cc1-9a39-626eae818c82" />

**הסבר הבדל ויעילות**

שתי השאילתות מחזירות רכבים שלא שובצו לנסיעות.
בצורה הראשונה משתמשים ב־NOT IN, כלומר בודקים אילו רכבים אינם נמצאים ברשימת הרכבים שהופיעו בנסיעות.
בצורה השנייה משתמשים ב־NOT EXISTS, כלומר בודקים עבור כל רכב האם לא קיימת עבורו נסיעה מתאימה.

בדרך כלל NOT EXISTS עדיף ובטוח יותר, במיוחד אם קיימים ערכי NULL.
NOT IN עלול להתנהג בצורה בעייתית כאשר תת־השאילתא מחזירה ערך NULL.
לכן מבחינת אמינות ויעילות, NOT EXISTS היא הצורה המומלצת יותר.


## 4 שאילתות SELECT נוספות

**5. Dashboard — כמות נסיעות לפי שנה וחודש**

**תיאור השאילתא**

שאילתא זו מיועדת למסך Dashboard.
היא מציגה כמה נסיעות היו בכל חודש ובכל שנה.
השאילתא משתמשת בפירוק שדה התאריך לשנה וחודש, ולכן היא עונה על דרישת השימוש בתאריכים.

**קוד השאילתא**

``` sql

SELECT 
    EXTRACT(YEAR FROM orderDate) AS rideYear,
    EXTRACT(MONTH FROM orderDate) AS rideMonth,
    COUNT(*) AS totalRides
FROM RIDE
GROUP BY EXTRACT(YEAR FROM orderDate), EXTRACT(MONTH FROM orderDate)
ORDER BY rideYear, rideMonth;

``` 

**צילום הרצה**

<img width="604" height="54" alt="image" src="https://github.com/user-attachments/assets/fef61161-569c-4084-ac4b-6336b285e0a5" />

**צילום תוצאה**

<img width="477" height="300" alt="image" src="https://github.com/user-attachments/assets/d0c7e6e1-563b-4ea9-bb4d-77785d347dff" />


**6. Route Analysis — המסלולים הפופולריים ביותר**
תיאור השאילתא

שאילתא זו מיועדת למסך ניתוח מסלולים / דוחות.
היא מציגה את המסלולים הנפוצים ביותר לפי מספר הנסיעות שבוצעו בכל מסלול.
השאילתא מחברת בין טבלת ROUTE לטבלת RIDE, ולכן היא לא טריוויאלית.

**קוד השאילתא**

``` sql

SELECT 
    RT.origin,
    RT.destination,
    RT.distanceKm,
    RT.estimatedTravelTime,
    COUNT(R.rideId) AS totalRidesOnRoute
FROM ROUTE RT
JOIN RIDE R
    ON RT.origin = R.origin
   AND RT.destination = R.destination
GROUP BY RT.origin, RT.destination, RT.distanceKm, RT.estimatedTravelTime
ORDER BY totalRidesOnRoute DESC, RT.origin, RT.destination;

``` 

**צילום הרצה**

<img width="1313" height="775" alt="image" src="https://github.com/user-attachments/assets/5bc10bf5-8614-4502-90e3-607aef47747c" />

**צילום תוצאה**

<img width="948" height="210" alt="image" src="https://github.com/user-attachments/assets/debf4439-5fad-4843-bb3f-7807b9f93411" />






**7. Track & Maintenance — רכבים עם הרבה נסיעות וללא תחזוקה לאחרונה**


**תיאור השאילתא**

שאילתא זו מיועדת למסך Fleet & Maintenance במערכת, והיא מציגה את צי הרכבים יחד עם מידע נוסף על פעילות ותחזוקה.

השאילתא מחזירה עבור כל רכב את פרטי הרכב (מספר רכב, דגם, צבע, שנה, קיבולת וסטטוס), וכן מידע מחושב הכולל את מספר הנסיעות שבוצעו עם הרכב ואת תאריך התחזוקה האחרון שלו.

השאילתא משלבת בין הטבלאות VEHICLE, RIDE ו-MAINTENANCE באמצעות LEFT JOIN, כך שגם רכבים ללא נסיעות או ללא תחזוקה יוצגו בתוצאה.

בנוסף, נעשה שימוש ב־GROUP BY כדי לחשב את מספר הנסיעות (COUNT) ואת תאריך התחזוקה האחרון (MAX) עבור כל רכב.

השאילתא אינה טריוויאלית משום שהיא משלבת נתונים ממספר טבלאות ומבצעת חישובים על הנתונים.


**קוד השאילתא**

``` sql

SELECT 
    V.plateNumber,
    V.model,
    V.carColor,
    V.year,
    V.capacity,
    V.status,
    COUNT(R.rideId) AS totalRides,
    MAX(M.maintenanceDate) AS lastMaintenanceDate
FROM VEHICLE V
LEFT JOIN RIDE R ON V.plateNumber = R.plateNumber
LEFT JOIN MAINTENANCE M ON V.plateNumber = M.plateNumber
GROUP BY 
    V.plateNumber, V.model, V.carColor, V.year, V.capacity, V.status
ORDER BY totalRides DESC;

``` 

**צילום הרצה**

<img width="717" height="71" alt="image" src="https://github.com/user-attachments/assets/30833f28-f56a-47d2-add1-ea3ae5288080" />

**צילום תוצאה**

<img width="1199" height="451" alt="image" src="https://github.com/user-attachments/assets/9d42b718-c6b5-430f-905e-83203c207dce" />




**8. Customer Details — היסטוריית נסיעות של לקוח מסוים**

**תיאור השאילתא**

שאילתא זו מיועדת למסך Customer Details במערכת, והיא מציגה את היסטוריית הנסיעות של לקוח מסוים.

השאילתא מסננת לקוח לפי מזהה (id), ובמקרה זה נבחר לקוח עם id = 1. לפי תוצאת השאילתא התקבלו 36 נסיעות שביצע הלקוח.

כל שורה בתוצאה מייצגת נסיעה אחת של אותו לקוח, וכוללת פרטים כמו תאריך הנסיעה (עם פירוק ליום, חודש ושנה), שעת התחלה, סטטוס ואמצעי תשלום, וכן פרטי הנהג והרכב.

השאילתא משלבת בין הטבלאות CUSTOMER, RIDE, DRIVER ו-VEHICLE באמצעות JOIN, ולכן היא אינה טריוויאלית ומציגה מידע מפורט שלא ניתן להסיק מטבלה אחת בלבד..

**קוד השאילתא**

``` sql

SELECT 
    C.id AS customerId,
    C.fullName AS customerName,
    C.phoneNumber AS customerPhone,
    R.rideId,
    R.orderDate,
    EXTRACT(DAY FROM R.orderDate) AS rideDay,
    EXTRACT(MONTH FROM R.orderDate) AS rideMonth,
    EXTRACT(YEAR FROM R.orderDate) AS rideYear,
    R.startTime,
    R.endTime,
    R.status AS rideStatus,
    R.paymentMethod,
    D.fullName AS driverName,
    V.plateNumber,
    V.model AS vehicleModel,
    R.origin,
    R.destination
FROM CUSTOMER C
JOIN RIDE R ON C.id = R.id
JOIN DRIVER D ON R.licenseNumber = D.licenseNumber
JOIN VEHICLE V ON R.plateNumber = V.plateNumber
WHERE C.id = 1
ORDER BY R.orderDate DESC, R.startTime DESC;

``` 

**צילום הרצה**

<img width="864" height="751" alt="image" src="https://github.com/user-attachments/assets/cc0d576c-e09c-4bf8-9421-75015e5f1aa5" />

**צילום תוצאה**

<img width="1190" height="201" alt="image" src="https://github.com/user-attachments/assets/06fca706-fdb5-4a3b-92a5-ced0a93b9a14" />



## שאילתות DELETE

**DELETE 1 — מחיקת נסיעות מבוטלות ישנות**

**תיאור השאילתא**

שאילתא זו מוחקת נסיעות שמסומנות כ־"cancelled" ושייכות לשנים קודמות בלבד.
המטרה היא לנקות מהמערכת נתונים ישנים ולא רלוונטיים.

השאילתא משתמשת בשדה תאריך (orderDate) ובפונקציית EXTRACT כדי לבדוק את השנה, ולכן עומדת בדרישת שימוש בתאריכים.

**קוד השאילתא**

``` sql

DELETE FROM RIDE
WHERE status = 'Cancelled'
  AND EXTRACT(YEAR FROM orderDate) < EXTRACT(YEAR FROM CURRENT_DATE);

  ``` 

**צילומים נדרשים**

צילום מצב לפני – הרצת SELECT עם אותם תנאים
צילום הרצה – ה־DELETEכולל rows affected
צילום מצב אחרי – הרצת SELECT שוב להראות שהרשומות נמחקו


<img width="1168" height="433" alt="image" src="https://github.com/user-attachments/assets/a8bdb7f8-7346-4ddd-817f-b7fa78242485" />

<img width="946" height="388" alt="image" src="https://github.com/user-attachments/assets/10b4c5a4-0d34-4cf2-9684-3c142a80198e" />

<img width="1133" height="501" alt="image" src="https://github.com/user-attachments/assets/b31af61d-acb1-42fa-b565-bf6a372df3c2" />





**DELETE 2 — מחיקת תחזוקה ישנה לרכבים פעילים**

**תיאור השאילתא**

שאילתא זו מוחקת רשומות תחזוקה ישנות (מעל שנתיים), אך רק עבור רכבים שאינם פעילים כיום.
המטרה היא לנקות מהמערכת מידע תחזוקה ישן שאינו רלוונטי לרכבים שאינם בשימוש, תוך שמירה על נתונים חשובים של רכבים פעילים.

השאילתא משלבת בין הטבלאות MAINTENANCE ו־VEHICLE באמצעות תת־שאילתא עם EXISTS, ובודקת עבור כל רשומת תחזוקה האם קיים רכב תואם שאינו פעיל.

בנוסף, נעשה שימוש בתנאי על שדה התאריך maintenanceDate כדי למחוק רק רשומות ישנות, ולכן השאילתא עומדת בדרישת שימוש בתאריכים.

השאילתא אינה טריוויאלית משום שהיא משלבת תנאי על תאריך יחד עם בדיקה של קשר בין טבלאות שונות, ולא פועלת על טבלה אחת בלבד.

**קוד השאילתא**

``` sql

DELETE FROM MAINTENANCE m
WHERE m.maintenanceDate < CURRENT_DATE - INTERVAL '2 years'
  AND EXISTS (
      SELECT 1
      FROM VEHICLE v
      WHERE v.plateNumber = m.plateNumber
        AND v.status <> 'Active'
  );

``` 

**צילומים נדרשים**

צילום מצב לפני – SELECT על MAINTENANCE עם התנאים
צילום הרצה – ה־DELETE + מספר רשומות שנמחקו
צילום מצב אחרי – SELECT שוב להראות שהרשומות נמחקו


<img width="1349" height="936" alt="image" src="https://github.com/user-attachments/assets/ae755932-b829-4bae-ac9b-80ac5a280439" />
<img width="1299" height="897" alt="image" src="https://github.com/user-attachments/assets/da6e0ac8-e553-407e-bf26-84742dea866b" />
<img width="1235" height="802" alt="image" src="https://github.com/user-attachments/assets/7d9c5b62-a5cb-4993-900e-3a6ee1db1664" />

**DELETE 3 — מחיקת נהגים לא פעילים ללא נסיעות**

**תיאור השאילתא**

שאילתא זו מוחקת נהגים שאינם פעילים ואין להם אף נסיעה במערכת.
מבחינה עסקית, נהגים כאלה אינם רלוונטיים למסך ניהול הנהגים, ולכן ניתן להסירם בלי לפגוע בהיסטוריית הנסיעות של המערכת.
השאילתא משתמשת בתת־שאילתא עם NOT EXISTS כדי לבדוק שאין לנהג אף נסיעה בטבלת RIDE, ולכן היא אינה טריוויאלית.

**קוד השאילתא**

``` sql

DELETE FROM DRIVER d
WHERE d.status <> 'Active'
  AND NOT EXISTS (
      SELECT 1
      FROM RIDE r
      WHERE r.licenseNumber = d.licenseNumber
  );

``` 

צילום מצב לפני – SELECT שמראה נהגים שאינם פעילים ואין להם נסיעות.
צילום הרצה – ה־DELETE ומספר הרשומות שנמחקו.
צילום מצב אחרי – SELECT שוב שמראה שאין יותר נהגים שעומדים בתנאי הזה.
<img width="1307" height="501" alt="image" src="https://github.com/user-attachments/assets/63e9f2b0-3329-401b-b993-0868a8788549" />
<img width="1306" height="701" alt="image" src="https://github.com/user-attachments/assets/b4eda5f3-895c-4622-a1ce-2f86c638411a" />
<img width="1304" height="492" alt="image" src="https://github.com/user-attachments/assets/1ab4ab4f-d7ba-4ede-9839-860413c56f1c" />

## שאילתות UPDATE

**UPDATE 1 —  עדכון סטטוס רכב ל־ Maintenance**

**תיאור השאילתא**

שאילתא זו מעדכנת את סטטוס הרכב ל־Maintenance עבור רכבים שסך עלויות התחזוקה שלהם בשנה הנוכחית גבוה מ־5000.
השאילתא מתאימה למסך Fleet & Maintenance, משום שהיא עוזרת לזהות רכבים שדורשים תשומת לב תחזוקתית מיוחדת.
השאילתא אינה טריוויאלית משום שהיא משתמשת בטבלת MAINTENANCE כדי לחשב את סכום עלויות התחזוקה לכל רכב, מבצעת GROUP BY ו־HAVING, ולאחר מכן מעדכנת את טבלת VEHICLE.

**קוד השאילתא**

``` sql

UPDATE VEHICLE
SET status = 'Maintenance'
WHERE plateNumber IN (
    SELECT m.plateNumber
    FROM MAINTENANCE m
    WHERE EXTRACT(YEAR FROM m.maintenanceDate) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY m.plateNumber
    HAVING SUM(m.Cost) > 5000
);

``` 

צילום מצב לפני – SELECT שמציג רכבים שסך עלויות התחזוקה שלהם בשנה הנוכחית גבוה מ־5000 ואת הסטטוס הנוכחי שלהם.
צילום הרצה – הרצת פקודת UPDATE והצגת מספר הרשומות שהתעדכנו.
צילום מצב אחרי – SELECT שמציג שאותם רכבים עודכנו לסטטוס Maintenance.

<img width="1383" height="808" alt="image" src="https://github.com/user-attachments/assets/8b3d9dd1-e486-4f14-ba1b-c5ebe3f1a592" />
<img width="1304" height="811" alt="image" src="https://github.com/user-attachments/assets/c321de8a-ba94-48eb-9eeb-00ba848b1a39" />
<img width="1334" height="771" alt="image" src="https://github.com/user-attachments/assets/fca13a08-fc76-460b-9dec-aef48ba45c97" />

**UPDATE 2 — עדכון נהגים ל־ Busy**

**תיאור השאילתא**

שאילתא זו מעדכנת את סטטוס הנהגים ל־Busy עבור נהגים שיש להם נסיעות בתאריך הנוכחי.
השאילתא מתאימה למסך ניהול הנהגים, כדי לזהות אילו נהגים פעילים ומשובצים לנסיעות היום.

השאילתא משתמשת בפירוק תאריך באמצעות EXTRACT ובתת־שאילתא כדי לזהות נהגים מתוך טבלת RIDE, ולכן אינה טריוויאלית.

**קוד השאילתא**

``` sql

UPDATE DRIVER
SET status = 'Busy'
WHERE licenseNumber IN (
    SELECT r.licenseNumber
    FROM RIDE r
    WHERE EXTRACT(YEAR FROM r.orderDate) = EXTRACT(YEAR FROM CURRENT_DATE)
      AND EXTRACT(MONTH FROM r.orderDate) = EXTRACT(MONTH FROM CURRENT_DATE)
      AND EXTRACT(DAY FROM r.orderDate) = EXTRACT(DAY FROM CURRENT_DATE)
);

``` 

צילום מצב לפני – SELECT שמראה את הנהגים שיש להם נסיעות היום ואת הסטטוס הנוכחי שלהם (לפני העדכון).
צילום הרצה – ה־UPDATE ומספר הרשומות שהתעדכנו (למשל UPDATE 16).
צילום מצב אחרי – SELECT שוב שמראה שהסטטוס של אותם נהגים עודכן ל־Busy.
<img width="1192" height="864" alt="image" src="https://github.com/user-attachments/assets/fc361990-3d74-456b-8094-e06c00c835df" />
<img width="1005" height="672" alt="image" src="https://github.com/user-attachments/assets/41a30a1a-4130-492e-842d-43fb24f8abdf" />
<img width="1511" height="797" alt="image" src="https://github.com/user-attachments/assets/87937f30-2e2d-414e-b87d-e46c50330783" />

**UPDATE 3 — עדכון נסיעות ארוכות ל־Long Completed**

**תיאור השאילתא**

שאילתא זו מעדכנת נסיעות שהסתיימו לסטטוס Long Completed, אם המסלול שלהן ארוך מ־100 ק״מ.
השאילתא מתאימה למסך דוחות נסיעות או למסך ניהול נסיעות, כדי לזהות ולסמן נסיעות ארוכות שבוצעו.
השאילתא אינה טריוויאלית משום שהיא משלבת בין הטבלאות RIDE ו־ROUTE, ומשתמשת בתנאי על מרחק המסלול (distanceKm), וכן בתנאי על סטטוס ותאריך הסיום של הנסיעה.

**קוד השאילתא**

``` sql

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

  ``` 

**צילומים נדרשים**

צילום מצב לפני – SELECT שמראה נסיעות שהסתיימו (Completed) והמסלול שלהן ארוך מ־100 ק״מ.
צילום הרצה – ה־UPDATE ומספר הרשומות שהתעדכנו.
צילום מצב אחרי – SELECT שוב שמראה שהסטטוס של אותן נסיעות עודכן ל־Long Completed.
<img width="1229" height="713" alt="image" src="https://github.com/user-attachments/assets/c0ff73bb-54e5-4607-b86d-aedbc5eea6e1" />
<img width="1137" height="727" alt="image" src="https://github.com/user-attachments/assets/31967fde-e918-4fbc-a39e-d104bb08637f" />
<img width="1348" height="800" alt="image" src="https://github.com/user-attachments/assets/9f797e96-a5f9-44d5-b5d2-034b858ea265" />


## rollback  ו commit: 

**עדכון בסיב הנתונים+rollback:**
BEGIN;

-- מצב בסיס הנתונים לפני העדכון

``` sql

SELECT licenseNumber, fullName, phoneNumber, status
FROM DRIVER
ORDER BY licenseNumber
LIMIT 5;

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

``` 

**צילומים נדרשים:**
צילום מצב בסיס הנתונים לפני העדכון.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/846c0bac-56c0-43be-abc2-81e57b525ea5" />
צילום מסך בסיס הנתונים לאחר העדכון.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b3ebd93c-ad52-494d-92f7-5140517d743b" />
צילום מצב בסיס הנתונים שחזר לקדמותו לאחר פקודת הrollback.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2ba1de3e-da15-48d5-a0f3-ff5b7d5dbe48" />


**עדכון בסיב הנתונים+commit:**

``` sql

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

``` 

**צילומים נדרשים:**

צילום מצב בסיס הנתונים לפני העדכון:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/023de181-2e57-4f6c-b1b4-90077b25aabc" />
צילום מסך בסיס הנתונים לאחר העדכון:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b290244e-de82-48fa-bbad-74eedc5209a9" />
צילום מצב בסיס הנתונים לאחר פקודת הcommit שנשאר כפי שהיה:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ad6375d9-65e4-4579-b208-fb808748c521" />

## אילוצים:

**אילוץ ראשון:**

``` sql

-- Constraint 1:
-- קיבולת רכב חייבת להיות גדולה מ- 0 כדי לא להכניס רכב ללא מושבים כלומר חסר משמעות
ALTER TABLE VEHICLE
ADD CONSTRAINT chk_vehicle_capacity_positive
CHECK (capacity > 0);

-- בדיקה שהאילוץ עובד, אמור להיכשל
INSERT INTO VEHICLE (plateNumber, model, capacity, carColor, year, status)
VALUES ('TEST001', 'Test Model', 0, 'White', 2020, 'Available');

``` 

תיאור האילוץ:   האילוץ מוודא שלא ניתן להכניס רכב עם קיבולת לא תקינה, כלומר קיבולת אפס או מספר שלילי.

צילום שגיאה לאחר ניסיון הכנסת ערך סותר:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b863535d-68f9-4c81-8881-6d052807cf49" />

**אילוץ שני:**

``` sql

-- =====================================================
-- Constraint 2:
-- מרחק נסיעה חייב להיות הגיוני (בתוך ישראל)
-- =====================================================

ALTER TABLE ROUTE
ADD CONSTRAINT chk_route_distance_valid
CHECK (distanceKm > 0 AND distanceKm <= 500)
NOT VALID;

-- בדיקה - אמור להיכשל
INSERT INTO ROUTE (origin, destination, distanceKm, estimatedTravelTime)
VALUES ('Test Origin', 'Test Destination', 800, 60);

``` 

**תיאור האילוץ:**   האילוץ מווודא שמרחק הנסיעה חיובי ואינו עולה על 500 ק"מ.
בעת הוספת האילוץ התברר כי קיימים נתונים בטבלה שאינם עומדים בתנאי האילוץ. לכן נעשה שימוש באפשרות NOT VALID, שמאפשרת להוסיף את האילוץ מבלי לבדוק את הנתונים הקיימים, אך עדיין לאכוף אותו על נתונים חדשים.

צילום שגיאה לאחר ניסיון הכנסת ערך סותר:

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/edb18a9b-634c-437f-a10b-c2527b618afd" />

**אילוץ שלישי:**

``` sql

-- =====================================================
-- Constraint 3:
-- זמן נסיעה משוער חייב להיות גדול מ-0
-- =====================================================

ALTER TABLE ROUTE
ADD CONSTRAINT chk_route_time_positive
CHECK (estimatedTravelTime > 0);

-- בדיקה - אמור להיכשל
INSERT INTO ROUTE (origin, destination, distanceKm, estimatedTravelTime)
VALUES ('Test Origin2', 'Test Destination2', 50, 0);

``` 

**תיאור האילוץ:** האילוץ מוודא שזמן הנסיעה המשוער גדול מ־0

צילום שגיאה לאחר ניסיון הכנסת ערך סותר:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/573d24fa-6a1a-4f13-824a-e152e9d3874d" />
הערה: ליד כל אילוץ מוסבר היטב מה משמעותו ומה מטרתו לפי הדרישה- כלומר מוטיבציה ותועלת.

## אינדקסים: 

**אינדקס 1: idx_ride_orderdate**

האינדקס נוסף על העמודה orderDate בטבלת RIDE.
המוטיבציה להוספת האינדקס היא שבמערכת קיימים מסכים שבהם המשתמש מחפש נסיעות לפי תאריך או לפי טווח תאריכים. מכיוון שטבלת הנסיעות גדולה ומכילה 20,000 רשומות, חיפוש לפי תאריך עלול להיות איטי יותר ללא אינדקס.
האינדקס מאפשר לבסיס הנתונים להגיע מהר יותר לרשומות הרלוונטיות במקום לעבור על כל הטבלה.

``` sql

-- =====================================================
-- Index 1: חיפוש נסיעות לפי תאריך
-- מתאים למסך ניהול נסיעות לפי טווח תאריכים
-- =====================================================

DROP INDEX IF EXISTS idx_ride_orderdate;

EXPLAIN ANALYZE
SELECT rideId, orderDate, startTime, endTime, status, paymentMethod
FROM RIDE
WHERE orderDate BETWEEN DATE '2026-03-01' AND DATE '2026-03-31'
ORDER BY orderDate, startTime;

``` 

<img width="868" height="34" alt="image" src="https://github.com/user-attachments/assets/8a036358-b91b-4390-8b72-19d51498f855" />

``` sql

CREATE INDEX idx_ride_orderdate
ON RIDE(orderDate);

EXPLAIN ANALYZE
SELECT rideId, orderDate, startTime, endTime, status, paymentMethod
FROM RIDE
WHERE orderDate BETWEEN DATE '2026-03-01' AND DATE '2026-03-31'
ORDER BY orderDate, startTime;

``` 

<img width="363" height="35" alt="image" src="https://github.com/user-attachments/assets/0fe93b7f-bd47-4d36-ba69-c2645682ab7a" />

**אינדקס 2: idx_ride_driver_date**

האינדקס נוסף על העמודות licenseNumber, orderDate בטבלת RIDE.
המוטיבציה היא שבמסך פרטי נהג נרצה להציג את היסטוריית הנסיעות של נהג מסוים לפי תאריכים. לכן האינדקס משלב גם את מספר הרישיון של הנהג וגם את תאריך הנסיעה.
התועלת היא שיפור בביצוע שאילתות שמסננות קודם לפי נהג ולאחר מכן לפי טווח תאריכים.

``` sql

-- =====================================================
-- Index 2: חיפוש נסיעות לפי נהג ותאריך
-- מתאים למסך פרטי נהג והיסטוריית נסיעות
-- =====================================================

DROP INDEX IF EXISTS idx_ride_driver_date;

EXPLAIN ANALYZE
SELECT rideId, licenseNumber, orderDate, startTime, endTime, status
FROM RIDE
WHERE licenseNumber = (
    SELECT licenseNumber
    FROM RIDE
    GROUP BY licenseNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
AND orderDate BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
ORDER BY orderDate;

``` 

<img width="332" height="49" alt="image" src="https://github.com/user-attachments/assets/6bc7c0b2-9e05-497b-b457-4cd72f9e06ac" />

``` sql

CREATE INDEX idx_ride_driver_date
ON RIDE(licenseNumber, orderDate);

EXPLAIN ANALYZE
SELECT rideId, licenseNumber, orderDate, startTime, endTime, status
FROM RIDE
WHERE licenseNumber = (
    SELECT licenseNumber
    FROM RIDE
    GROUP BY licenseNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
AND orderDate BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
ORDER BY orderDate;

``` 

<img width="312" height="37" alt="image" src="https://github.com/user-attachments/assets/b0057f63-f467-4443-be4e-bb61e65b8781" />

**אינדקס 3: idx_maintenance_vehicle_date**

האינדקס נוסף על העמודות plateNumber, maintenanceDate בטבלת MAINTENANCE.
המוטיבציה היא שבמסך פרטי רכב נרצה לראות את כל היסטוריית הטיפולים של רכב מסוים, בדרך כלל לפי תאריך.
מכיוון שטבלת התחזוקה מכילה 20,000 רשומות, האינדקס עוזר לשלוף מהר יותר את הטיפולים של רכב מסוים.

``` sql

-- =====================================================
-- Index 3: חיפוש טיפולים לפי רכב ותאריך
-- מתאים למסך רכב והיסטוריית טיפולים
-- =====================================================

DROP INDEX IF EXISTS idx_maintenance_vehicle_date;

EXPLAIN ANALYZE
SELECT plateNumber, maintenanceDate, MaintenanceType, Cost, Description
FROM MAINTENANCE
WHERE plateNumber = (
    SELECT plateNumber
    FROM MAINTENANCE
    GROUP BY plateNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
ORDER BY maintenanceDate DESC;

``` 

<img width="370" height="33" alt="image" src="https://github.com/user-attachments/assets/d179cfad-1a21-4790-9f69-1944fb8c91dd" />

``` sql

CREATE INDEX idx_maintenance_vehicle_date
ON MAINTENANCE(plateNumber, maintenanceDate);

EXPLAIN ANALYZE
SELECT plateNumber, maintenanceDate, MaintenanceType, Cost, Description
FROM MAINTENANCE
WHERE plateNumber = (
    SELECT plateNumber
    FROM MAINTENANCE
    GROUP BY plateNumber
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
ORDER BY maintenanceDate DESC;

``` 

<img width="323" height="31" alt="image" src="https://github.com/user-attachments/assets/b3ec90cc-4bd6-46dc-88fc-ba2b9b37406e" />

לאחר הוספת האינדקס ניתן לראות ירידה בזמן הריצה של השאילתה. הסיבה לכך היא שבסיס הנתונים לא היה צריך לסרוק את כל הטבלה, אלא השתמש באינדקס כדי להגיע מהר יותר לשורות המתאימות.


## <a id="phase-3"></a>שלב ג

**תרשים ERD משולב :**
<img width="5025" height="2028" alt="erdplus (6)" src="https://github.com/user-attachments/assets/dd4e8fa7-e173-439d-b331-9308e76ebdab" />


**תרשים DSD משולב :**
<img width="1404" height="1054" alt="integrated-dsd" src="https://github.com/user-attachments/assets/f9ba86ac-d1ea-433e-996a-e69b9714cc89" />

## <a id="integration-decisions"></a>החלטות שנעשו בשלב האינטגרציה :

שינויים שבוצעו במיזוג ה־ERD
בוצע חיבור בין היישויות Ride ו־TourInstance באמצעות קשר בשם transportFor.
הוסרו המאפיינים הבאים מהיישות Ride:

``` sql

date
startRide
endRide
payment

```

**הסיבה למחיקות:**

התאריך מתקבל מתוך TourInstance.
התשלום מתקבל מתוך Order.
לכן המידע נחשב כפול ואין צורך לשמור אותו גם ב־Ride.
היישות Customer הוסרה מהדיאגרמה השנייה כדי למנוע כפילות נתונים לאחר מיזוג שתי המערכות.

## <a id="process-explanation"></a>הסבר מילולי של התהליך והפקודות:

בתהליך האינטגרציה חיברנו בין שני מסדי נתונים שונים למערכת אחת משותפת.
המטרה הייתה לאחד את הנתונים, למנוע כפילויות, ולהתאים את מבני הטבלאות כך שיוכלו לעבוד יחד בצורה תקינה.

תחילה השתמשנו בפקודות ALTER TABLE כדי לשנות את מבנה הטבלאות הקיימות.
באמצעות DROP COLUMN מחקנו שדות מטבלת ride שכבר לא היו נחוצים לאחר המיזוג, משום שהמידע שלהם נשמר בטבלאות אחרות במערכת.

לאחר מכן השתמשנו ב־RENAME COLUMN כדי לשנות שמות של עמודות בטבלת customer, כך שיתאימו למבנה שהתקבל מהמערכת השנייה.
בנוסף, בעזרת ADD COLUMN הוספנו עמודות חדשות עבור שם פרטי ושם משפחה.

באמצעות פקודת UPDATE עדכנו את הנתונים הקיימים ופיצלנו את השדה fullname לשני שדות נפרדים.
לאחר שהמידע הועבר בהצלחה, מחקנו את העמודה הישנה בעזרת DROP COLUMN.

בהמשך הפעלנו את הרחבת dblink באמצעות CREATE EXTENSION, כדי לאפשר חיבור למסד הנתונים השני וייבוא מידע ממנו.

לאחר מכן השתמשנו בפקודות CREATE TABLE AS ו־INSERT INTO כדי ליצור טבלאות חדשות ולהעתיק אליהן נתונים ממסד הנתונים החיצוני.
כך ייבאנו טבלאות כמו:
guide, station, tour, tourinstance, tourstation ו־bookings.

בנוסף, ייבאנו לקוחות ממסד הנתונים השני.
כדי למנוע התנגשויות בין מזהים קיימים, הוספנו 10000 לערכי ה־c_id של הלקוחות שיובאו.

לאחר ייבוא הנתונים יצרנו מחדש קשרים בין הטבלאות באמצעות:

PRIMARY KEY לזיהוי ייחודי של רשומות.
FOREIGN KEY ליצירת קשרים בין טבלאות.
UNIQUE למניעת כפילויות.

בשלב האחרון חיברנו בין ride לבין tourinstance באמצעות השדה t_i_id, שיצר את הקשר transportFor.

לבסוף השתמשנו ב־UPDATE יחד עם ROW_NUMBER() כדי לשייך בצורה אוטומטית מופעי סיור לנסיעות הקיימות במערכת.

כל התהליך נועד ליצור מסד נתונים מאוחד, מסודר ותקין, תוך שמירה על קשרים נכונים בין הישויות ומניעת כפילויות מידע.




## <a id="view-1"></a>מבט 1: driver_rides_view

**תיאור המבט:**

המבט מציג את רשימת הנהגים במערכת ההסעות ואת מספר הנסיעות שיש לכל נהג.
המבט מחבר בין טבלת הנהגים לבין טבלת הנסיעות לפי מספר רישיון הנהג.

תמונת תוצאות הרצה נמצא בשאילת הראשונה 

**שאילת 1**

``` sql

SELECT *
FROM driver_rides_view
LIMIT 10;
```

**פלט הרצת שאילת:**
<img width="746" height="652" alt="image" src="https://github.com/user-attachments/assets/f76532e5-514e-46e9-9edc-40c21101f452" />


**שאילת 2**

השאילתה מציגה רק נהגים שיש להם יותר מ־5 נסיעות, וממיינת אותם לפי מספר הנסיעות מהגבוה לנמוך.

**קוד השאילתה:**

``` sql

SELECT *
FROM driver_rides_view
WHERE total_rides > 5
ORDER BY total_rides DESC;

```

**פלט הרצת שאילת:**

<img width="946" height="701" alt="image" src="https://github.com/user-attachments/assets/6d813a28-9e64-4ca1-9d5e-6df1d8051355" />


## <a id="view-2"></a>מבט 2: approved_bookings_view

**תיאור המבט:**

המבט מציג את כל ההזמנות המאושרות של מערכת הסיורים.
המבט מחבר בין טבלת ההזמנות, טבלת מופעי הסיור וטבלת הסיורים, כך שניתן לראות עבור כל הזמנה מאושרת את פרטי ההזמנה, תאריך ושעות הסיור, שם הסיור, האזור, סוג הסיור והמחיר.

תמונת תוצאות הרצה נמצא בשאילת הראשונה

**שאילת 1:**

``` sql

SELECT *
FROM approved_bookings_view
LIMIT 10;

```

**פלט הרצת שאילת:**

<img width="1497" height="651" alt="image" src="https://github.com/user-attachments/assets/efc7bda0-5ee6-454a-aea0-4af074c1e85b" />



**שאילת 2**

**תיאור השאילתה**

השאילתה מחשבת עבור כל סיור את מספר ההזמנות המאושרות ואת סך ההכנסות ממנו.
התוצאה ממוינת לפי ההכנסה הכוללת מהגבוה לנמוך.

**קוד השאילתה:**

``` sql

SELECT
    t_name,
    COUNT(*) AS approved_bookings_count,
    SUM(total_price) AS total_income
FROM approved_bookings_view
GROUP BY t_name
ORDER BY total_income DESC;

```

**פלט הרצת שאילת:**

<img width="1015" height="663" alt="image" src="https://github.com/user-attachments/assets/d218a75b-ceb3-4537-a4d5-49b598434ac1" />




# שלב ד - תכנות 

### תיאור מילולי – תוכנית ראשית א
התוכנית הראשית מרכזת את הפעלת כל הרכיבים שפותחו במסגרת שלב ד'. בתחילת הריצה היא מפעילה את הפונקציה get_transport_tours_report, אשר מפיקה דוח על טיולים המשויכים להסעות במערכת המשולבת. הפונקציה סורקת את הנתונים באמצעות Cursor, בודקת את המידע ומחזירה את תוצאות הדוח באמצעות Ref Cursor.

לאחר קבלת ה־Ref Cursor, התוכנית מבצעת FETCH ומציגה חמש רשומות מהדוח. בכל רשומה מוצגים פרטים כגון מספר הנסיעה, שם הטיול, שם הנהג, דגם הרכב וההכנסה שנוצרה מהטיול. בנוסף, הפונקציה מדווחת כי נסרקו 250 טיולים המשויכים להסעות, ומתוכם נמצאו 7 טיולים בעלי הזמנות מאושרות.

בהמשך, התוכנית מפעילה את הפרוצדורה update_pending_transport_rides, אשר מאתרת נסיעות במצב Pending ומעדכנת שלוש מהן למצב Completed. במהלך ביצוע העדכונים מופעל הטריגר trg_check_ride_status_update, אשר מזהה את שינוי הסטטוס ומציג הודעה עבור כל נסיעה שעודכנה.

בצילום המסך ניתן לראות כי שלוש נסיעות (3239, 7675 ו־912) עודכנו בהצלחה מ־Pending ל־Completed, הטריגר הופעל עבור כל אחת מהן, והפרוצדורה סיימה את עבודתה בהצלחה לאחר שביצעה שלושה עדכונים.

בסיום התהליך מוצגת הודעה המעידה כי הפונקציה, הפרוצדורה והטריגר פעלו בהצלחה, והתוכנית הראשית הסתיימה ללא שגיאות. צילום המסך מהווה הוכחה לכך שכל רכיבי המערכת פעלו כנדרש על בסיס הנתונים המשולב.



### קוד התוכנית – תוכנית ראשית א
```sql

-- =====================================================
-- File: 04_main_transport_tours.sql
-- Stage D - Main Program
-- Student: Tirtsa Abuhasira
-- Database: restore_final_db
--
-- Purpose:
-- Main program that calls:
-- 1. Function: get_transport_tours_report
-- 2. Procedure: update_pending_transport_rides
--
-- Programming elements demonstrated:
-- - Ref Cursor
-- - Record Variable
-- - Loop
-- - Function Call
-- - Procedure Call
-- - Exception Handling
-- =====================================================

DO $$

DECLARE
    -- Cursor returned from the function
    report_cursor REFCURSOR;

    -- Record used for FETCH operations
    report_record RECORD;

    -- Counter of displayed rows
    row_counter INTEGER := 0;

BEGIN
    RAISE NOTICE '================================';
    RAISE NOTICE 'Main program started';
    RAISE NOTICE '================================';

    -- Call function with minimum tour price 300.
    -- This keeps the output readable but still returns rows.
    report_cursor := get_transport_tours_report(300);

    RAISE NOTICE
    'Function get_transport_tours_report executed successfully';

    -- Display only first 5 rows from the Ref Cursor
    LOOP
        FETCH report_cursor INTO report_record;

        EXIT WHEN NOT FOUND;
        EXIT WHEN row_counter >= 5;

        row_counter := row_counter + 1;

        RAISE NOTICE
        'Row % | Ride % | Tour % | Driver % | Vehicle % | Income %',
        row_counter,
        report_record.rideid,
        report_record.t_name,
        report_record.driver_name,
        report_record.vehicle_model,
        report_record.total_income;
    END LOOP;

    -- Close cursor after using it
    CLOSE report_cursor;

    RAISE NOTICE
    'Displayed rows from cursor: %',
    row_counter;

    -- Call procedure.
    -- It updates 3 Pending rides to Completed.
    CALL update_pending_transport_rides(3);

    RAISE NOTICE
    'Procedure update_pending_transport_rides executed successfully';

    RAISE NOTICE '================================';
    RAISE NOTICE 'Main program finished';
    RAISE NOTICE '================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE
        'Error in main program: %',
        SQLERRM;
END;
$$;

```

### פלט הרצת התוכנית – תוכנית ראשית א
<img width="1129" height="738" alt="image" src="https://github.com/user-attachments/assets/4137a4cd-d17b-44b8-aa3b-3d334a1a663f" />

### תיאור מילולי – תוכנית ראשית ב

התוכנית הראשית מרכזת את הפעלת כל הרכיבים שפותחו במסגרת שלב ד' בנושא ניהול הזמנות לקוחות במערכת המשולבת. בתחילת הריצה היא מפעילה את הפונקציה get_customer_bookings_report, אשר מפיקה דוח על לקוחות וההזמנות שביצעו במערכת. הפונקציה סורקת את הנתונים באמצעות Explicit Cursor, מבצעת ניתוח של נתוני ההזמנות, ומחזירה את תוצאות הדוח באמצעות Ref Cursor.

במהלך ביצוע הפונקציה נסרקו 1200 לקוחות במערכת, מתוכם נמצאו 500 לקוחות פעילים בעלי הזמנות מאושרות. בנוסף, חושב סך ההכנסות הכולל מההזמנות בדוח, אשר עמד על 15,262,723, ונמצא כי הלקוח בעל ההיקף הכספי הגבוה ביותר הוא Bobbette Caccavari עם סכום מצטבר של 55,401.

לאחר קבלת ה־Ref Cursor, התוכנית מבצעת FETCH ומציגה חמש רשומות מהדוח. בכל רשומה מוצגים פרטים כגון שם הלקוח, מספר ההזמנות המאושרות, מספר ההזמנות שלא אושרו, סך התשלומים שביצע וסיווג הלקוח. בצילום המסך ניתן לראות את חמשת הלקוחות המובילים בדוח ואת הנתונים שחושבו עבור כל אחד מהם.

בהמשך, התוכנית מפעילה את הפרוצדורה clean_old_unapproved_bookings, אשר מאתרת הזמנות ישנות שלא אושרו ומבצעת עדכון של ערך total_price ל־0, כך שלא ייחשבו כהכנסה במערכת. במהלך הריצה נסרקו 36 הזמנות, מתוכן עודכנו 10 הזמנות ו־26 הזמנות נוספות דולגו בהתאם לתנאי הפרוצדורה. בנוסף, חושב הסכום הכולל שנוקה מהמערכת, אשר עמד על 5,106.

במהלך ביצוע העדכונים הופעל הטריגר trg_customer_bookings_update. הטריגר זיהה את השינויים שבוצעו בהזמנות והציג הודעות עבור כל הזמנה שעודכנה. לאחר מכן ביצעה התוכנית הדגמה נוספת של פעולת הטריגר, כאשר ניסתה לעדכן את ערך total_price של הזמנה מספר 54 ל־999. הטריגר הופעל באופן אוטומטי, זיהה כי מדובר בהזמנה שאינה מאושרת, והחזיר את הערך ל־0 בהתאם לכללי המערכת.

בסיום התהליך מוצגות הודעות המעידות כי הפונקציה, הפרוצדורה והטריגר פעלו בהצלחה. צילום המסך מהווה הוכחה לכך שהפונקציה הפיקה דוח באמצעות Ref Cursor, הפרוצדורה ביצעה עדכונים בבסיס הנתונים, הטריגר הופעל באופן אוטומטי בעת ביצוע עדכונים, והתוכנית הראשית הסתיימה בהצלחה ללא שגיאות.


### קוד התוכנית – תוכנית ראשית ב


```sql
-- =====================================================
-- File: 08_main_customer_bookings.sql
-- Stage D - Main Program
--
-- Purpose:
-- Main program that calls:
-- 1. Function: get_customer_bookings_report
-- 2. Procedure: clean_old_unapproved_bookings
--
-- It also demonstrates the booking trigger by running an UPDATE.
--
-- Programming elements:
-- 1. Ref Cursor
-- 2. Record variable
-- 3. Loop
-- 4. Function call
-- 5. Procedure call
-- 6. UPDATE statement that activates the trigger
-- 7. Exception handling
-- =====================================================

DO $$

DECLARE
    report_cursor REFCURSOR;
    report_record RECORD;
    row_counter INTEGER := 0;

    test_booking_id INTEGER;
    price_before NUMERIC;
    price_after NUMERIC;

BEGIN
    RAISE NOTICE '================================';
    RAISE NOTICE 'Customer bookings main program started';
    RAISE NOTICE '================================';

    -- Call function 05 and receive a Ref Cursor
    report_cursor := get_customer_bookings_report(0);

    RAISE NOTICE 'Top 5 customers from Ref Cursor:';

    LOOP
        FETCH report_cursor INTO report_record;

        EXIT WHEN NOT FOUND;
        EXIT WHEN row_counter >= 5;

        row_counter := row_counter + 1;

        RAISE NOTICE
        '% | Customer: % | Approved: % | Unapproved: % | Total paid: % | Type: %',
        row_counter,
        report_record.customer_name,
        report_record.approved_bookings,
        report_record.unapproved_bookings,
        report_record.total_paid,
        report_record.customer_type;
    END LOOP;

    CLOSE report_cursor;

    RAISE NOTICE 'Displayed rows: %', row_counter;

    -- Call procedure 06
    CALL clean_old_unapproved_bookings('2026-01-01', 10);

    -- Demonstrate trigger 07
    SELECT b_id, total_price
    INTO test_booking_id, price_before
    FROM bookings
    WHERE b_status = FALSE
    LIMIT 1;

    IF test_booking_id IS NOT NULL THEN

        UPDATE bookings
        SET total_price = 999
        WHERE b_id = test_booking_id;

        SELECT total_price
        INTO price_after
        FROM bookings
        WHERE b_id = test_booking_id;

        RAISE NOTICE 'Trigger demonstration:';
        RAISE NOTICE 'Booking id: %', test_booking_id;
        RAISE NOTICE 'Tried to set total_price to: 999';
        RAISE NOTICE 'Actual total_price after trigger: %', price_after;

    ELSE
        RAISE NOTICE 'No unapproved booking found for trigger demonstration';
    END IF;

    RAISE NOTICE '================================';
    RAISE NOTICE 'Customer bookings main program finished';
    RAISE NOTICE '================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in customer bookings main program: %', SQLERRM;
END;
$$;
```

### פלט הרצת התוכנית – תוכנית ראשית ב

<img width="803" height="686" alt="image" src="https://github.com/user-attachments/assets/40fe8c7d-9f62-4b0e-af77-3f7779fca87c" />
<img width="897" height="456" alt="image" src="https://github.com/user-attachments/assets/4e0225d9-456c-4fb7-9c9b-95b38ba4b2f1" />



# שלב ה' - ממשק משתמש גרפי (GUI) למערכת TransRoute

ממשק משתמש אינטראקטיבי, מעוצב ונוח המקשר בין המשתמש לבסיס הנתונים של פרויקט TransRoute.

## 🚀 הוראות כניסה והפעלה של המערכת

### 1. דרישות קדם (Prerequisites)
* **Python 3.x** מותקן במחשב.
* **Docker Desktop** פועל (על מנת להריץ את בסיס הנתונים PostgreSQL).

### 2. הפעלת בסיס הנתונים (Docker)
פתח טרמינל בתיקיית השורש של הפרויקט והרם את קונטיינר בסיס הנתונים:
```bash
docker-compose up -d
```
*פעולה זו תפעיל את ה-PostgreSQL על פורט `5432` ואת ה-pgAdmin על פורט `8080`.*

### 3. התקנת ספריות פייתון (Python Dependencies)
עבור אל תיקיית הממשק הגרפי והתקן את הספריות הנדרשות:
```bash
cd "שלב ה/app"
pip install -r requirements.txt
```
*הספריות שיותקנו הן: `Flask` (שרת האינטרנט), `psycopg2-binary` (התקשרות ל-PostgreSQL), ו-`python-dotenv` (טעינת משתני סביבה).*

### 4. הרצת האפליקציה
הרע את שרת ה-Flask באמצעות הפקודה:
```bash
python app.py
```
לאחר ההרצה, השרת יהיה זמין בדפדפן בכתובת:
👉 **[http://127.0.0.1:5000](http://127.0.0.1:5000)**

---

## 🛠️ הסבר על כלי הפיתוח ודרך העבודה

* **Backend (שרת אחורי):** נבנה באמצעות **Python** וספריית המיקרו-פריימוורק **Flask**. Flask נבחרה בגלל שהיא קלה, מהירה ומאפשרת בנייה פשוטה של API נקודתי (RESTful API) המקשר ישירות לשאילתות ה-SQL. החיבור ל-PostgreSQL מתבצע באמצעות דרייבר `psycopg2` תוך שימוש במשתני הסביבה המוגדרים בקובץ ה-`.env`.
* **Frontend (ממשק קדמי):** נבנה בצורת **Single-Page Application (SPA)** באמצעות **Vanilla HTML5, CSS3, ו-JavaScript (ES6)**, ללא שימוש בפריימוורקים כבדים.
* **עיצוב (Styling):** עיצוב מותאם אישית (Custom CSS) בסגנון **Dark Mode Glassmorphism** (מראה זכוכית מעוצב, מעברים מונפשים, צבעים יוקרתיים וסרגלי כלים נוחים למשתמש). נעשה שימוש בגופן **Heebo** מבית Google Fonts להתאמה מושלמת לשפה העברית.

---

## 💻 פירוט מסכי המערכת ויכולותיהם

### 1. מסך כניסה (Login Screen)
* מסך פתיחה חגיגי עם בדיקת חיבור אוטומטית לבסיס הנתונים.
* המערכת תאשר כניסה (הכפתור "כניסה למערכת" ייפתח) רק במידה ונוצר חיבור תקין ל-Postgres.

### 2. לוח בקרה (Dashboard)
* מציג סיכום סטטיסטי בזמן אמת של כמות הנתונים בכל אחת מ-11 הטבלאות במערכת (נהגים, לקוחות, נסיעות, רכבים וכו').

### 3. מסכי CRUD מלאים (לכל הטבלאות)
* **קריאה (Read):** הצגת טבלאות נתונים נקיות הכוללות מנגנון חיפוש מהיר המפלטר את הטבלה בזמן אמת.
* **תרגום מפתחות זרים (Foreign Key Resolution):** לפי דרישות הפרויקט, המשתמש לא רואה IDs בלתי מובנים (למשל מזהה לקוח 10005 או מספר רכב), אלא המערכת מבצעת JOIN ומציגה את **שם הלקוח המלא**, **דגם הרכב**, **שם המדריך** וכו'.
* **עדכון (Update):** בלחיצה על ערוך, המערכת מזהה את מפתח הרשומה, מושכת אוטומטית את יתר השדות מבסיס הנתונים לתוך טופס מודאלי ומאפשרת למשתמש לעדכן אותם ולשמור.
* **הכנסה (Insert):** לחיצה על הוספה פותחת טופס ריק. שדות המקושרים למפתחות זרים מוצגים כתיבות בחירה (Select Dropdowns) המאוכלסות דינמית מהנתונים הקיימים (למשל: בחירת נהג מתוך רשימת הנהגים הקיימת).
* **מחיקה (Delete):** כפתור מחיקה עם שאלת אישור (Confirm) למניעת מחיקות שגויות.

### 4. מסך שאילתות (שלב ב')
מאפשר הרצת שאילתות מורכבות משלב ב' עם קלט מהמשתמש:
* **נהגים מצטיינים:** דירוג נהגים לפי כמות נסיעות בשנה נבחרת.
* **לקוחות מובילים:** מציאת הלקוחות שביצעו הכי הרבה הזמנות בחודש ושנה מוגדרים.
* **רכבים לא פעילים:** מציאת רכבים שלא שובצו לאף נסיעה בשנה מסוימת.
* **מסלולים פופולריים:** ניתוח המסלולים המבוקשים ביותר בשנה מסוימת.

### 5. מסך פונקציות ופרוצדורות (שלב ד')
הרצת תתי-התוכניות שיצרנו בשלב ד' ישירות מהממשק:
* **הפקת דוח סיורים ותחבורה משולב:** קריאה לפונקציה `get_transport_tours_report(min_price)` והצגת התוצאות בטבלה.
* **עדכון המוני של נסיעות ממתינות:** הפעלת הפרוצדורה `update_pending_transport_rides(max_updates)` המעבירה נסיעות במצב Pending למצב Completed ומציגה הודעת סיכום.
* **הפקת דוח לקוחות והזמנות:** הפעלת הפונקציה `get_customer_bookings_report(min_price)` המקטלגת לקוחות לפי רמת פעילותם.
* **ניקוי הזמנות ישנות שלא אושרו:** הפעלת הפרוצדורה `clean_old_unapproved_bookings(before_date, max_updates)` המאפסת מחירים של הזמנות ממתינות ישנות.



##  תמונות מסך של הפעלת האפליקציה

<img width="1278" height="771" alt="צילום מסך 2026-06-15 214946" src="https://github.com/user-attachments/assets/7e968195-f70f-4097-8e6f-902eb7179da3" />
<img width="1551" height="367" alt="צילום מסך 2026-06-15 224526" src="https://github.com/user-attachments/assets/3aafedfe-99a0-4e93-b197-2fdbefbda8da" />
<img width="1532" height="707" alt="צילום מסך 2026-06-15 224444" src="https://github.com/user-attachments/assets/c21cb0c4-f2ec-4af2-91c5-19c389116a7b" />
<img width="1552" height="337" alt="צילום מסך 2026-06-15 224415" src="https://github.com/user-attachments/assets/3495af15-ffda-49d4-88b0-68e9e907276b" />
<img width="1556" height="697" alt="צילום מסך 2026-06-15 224348" src="https://github.com/user-attachments/assets/c24ffd4f-d826-4545-972d-8e62b8c7c5e7" />
<img width="1477" height="885" alt="צילום מסך 2026-06-15 224258" src="https://github.com/user-attachments/assets/758e0225-7113-4805-9087-28cdb1b9367e" />
<img width="1535" height="667" alt="צילום מסך 2026-06-15 224232" src="https://github.com/user-attachments/assets/6fe70544-ee21-47d3-8f0f-1c889c1a9488" />
<img width="703" height="572" alt="צילום מסך 2026-06-15 224146" src="https://github.com/user-attachments/assets/05480b0f-6f9e-4c6e-b5ce-88ea5db6af84" />
<img width="688" height="572" alt="צילום מסך 2026-06-15 224121" src="https://github.com/user-attachments/assets/a40856c0-02a1-4129-a911-babb17fac8cb" />
<img width="957" height="558" alt="צילום מסך 2026-06-15 224024" src="https://github.com/user-attachments/assets/dc299a30-04a0-4a61-ad49-6254ac8476b6" />
<img width="702" height="540" alt="צילום מסך 2026-06-15 223944" src="https://github.com/user-attachments/assets/15f2d411-2eff-417d-8509-fa5f584a0546" />
<img width="688" height="532" alt="צילום מסך 2026-06-15 223912" src="https://github.com/user-attachments/assets/442020bd-ec98-4f59-90d0-0006248625a7" />
<img width="687" height="752" alt="צילום מסך 2026-06-15 223825" src="https://github.com/user-attachments/assets/721d671d-69f5-45e4-9060-08ffa1c433d8" />
<img width="697" height="755" alt="צילום מסך 2026-06-15 223748" src="https://github.com/user-attachments/assets/0ddd3d5e-c09e-4c7b-93c6-7354ef4ae3e6" />
<img width="690" height="762" alt="צילום מסך 2026-06-15 223646" src="https://github.com/user-attachments/assets/52af2a60-fde8-442d-9af5-0f6fe969e6f7" />
<img width="688" height="752" alt="צילום מסך 2026-06-15 223617" src="https://github.com/user-attachments/assets/04bd9f6a-4bc1-462d-80c6-16e1f4dd2daf" />
<img width="687" height="762" alt="צילום מסך 2026-06-15 223455" src="https://github.com/user-attachments/assets/e8f13e41-f271-4f66-a41d-7e23f3bf987a" />
<img width="696" height="761" alt="צילום מסך 2026-06-15 223425" src="https://github.com/user-attachments/assets/211af762-0668-4bb4-8a64-0be07bb7ea16" />
<img width="706" height="682" alt="צילום מסך 2026-06-15 223150" src="https://github.com/user-attachments/assets/9d446493-07eb-4468-b569-7b58b2b0c775" />
<img width="702" height="677" alt="צילום מסך 2026-06-15 223111" src="https://github.com/user-attachments/assets/cbe35659-27ff-4715-8fcf-95a586ee6640" />
<img width="697" height="732" alt="צילום מסך 2026-06-15 222438" src="https://github.com/user-attachments/assets/77066d26-d14b-42a4-a7a5-ccf2752fc0e6" />
<img width="1076" height="940" alt="צילום מסך 2026-06-15 222327" src="https://github.com/user-attachments/assets/f6fd12fb-e2ee-4cda-93ae-67ac93a371cd" />
<img width="708" height="766" alt="צילום מסך 2026-06-15 222221" src="https://github.com/user-attachments/assets/c5c285ee-9b64-4da2-b74a-fe4b44777503" />
<img width="686" height="750" alt="צילום מסך 2026-06-15 222153" src="https://github.com/user-attachments/assets/3b9fdc32-38db-4158-8edc-b8ddadb8addd" />
<img width="1553" height="912" alt="צילום מסך 2026-06-15 222111" src="https://github.com/user-attachments/assets/39556e33-e656-4768-ba66-0014192bc844" />
<img width="718" height="583" alt="צילום מסך 2026-06-15 221759" src="https://github.com/user-attachments/assets/36cc40df-d025-4d85-8d6d-1260c00e24e6" />
<img width="712" height="580" alt="צילום מסך 2026-06-15 221715" src="https://github.com/user-attachments/assets/b05153fe-437e-45e4-8eb6-a40ab329adc7" />
<img width="707" height="761" alt="צילום מסך 2026-06-15 221611" src="https://github.com/user-attachments/assets/726ee55f-21de-4f6f-a115-89347227e053" />
<img width="706" height="766" alt="צילום מסך 2026-06-15 221532" src="https://github.com/user-attachments/assets/ce7b2a60-d9cf-470f-b321-d5fe8352e89a" />
<img width="1616" height="652" alt="צילום מסך 2026-06-15 221441" src="https://github.com/user-attachments/assets/21983b44-be62-46f7-8c2e-344c8c8c747b" />
<img width="722" height="686" alt="צילום מסך 2026-06-15 221341" src="https://github.com/user-attachments/assets/a7ab1ebc-d243-423b-8b2e-843e9b8aa5ea" />
<img width="717" height="702" alt="צילום מסך 2026-06-15 221254" src="https://github.com/user-attachments/assets/fd94797c-6022-44d4-bcdb-285c61ac71ad" />
<img width="1492" height="297" alt="צילום מסך 2026-06-15 221210" src="https://github.com/user-attachments/assets/0f2a3b1b-c0fb-47af-b543-99e3f0437ff1" />
<img width="710" height="610" alt="צילום מסך 2026-06-15 220859" src="https://github.com/user-attachments/assets/dafcd128-c243-4ba2-8def-be2092d161c9" />
<img width="1537" height="156" alt="צילום מסך 2026-06-15 220805" src="https://github.com/user-attachments/assets/d1c519bd-38b4-4487-9e0b-631a7b6b98f9" />
<img width="700" height="586" alt="צילום מסך 2026-06-15 220726" src="https://github.com/user-attachments/assets/171e770a-a989-488a-92de-49fcd372f30b" />
<img width="1874" height="919" alt="צילום מסך 2026-06-15 220426" src="https://github.com/user-attachments/assets/557890db-323d-40a4-b176-a2dc9745bd96" />
<img width="1895" height="922" alt="צילום מסך 2026-06-15 220137" src="https://github.com/user-attachments/assets/4dc828da-aa9b-4116-819d-f0d5c6246c6a" />
<img width="1892" height="918" alt="צילום מסך 2026-06-15 220052" src="https://github.com/user-attachments/assets/1fc5179d-26d7-4006-856d-a19441a52e1d" />
<img width="1877" height="887" alt="צילום מסך 2026-06-15 220017" src="https://github.com/user-attachments/assets/876c728c-7e67-4cd7-9a0c-fc173b2fa25c" />
<img width="1896" height="910" alt="צילום מסך 2026-06-15 215934" src="https://github.com/user-attachments/assets/614cd584-9c2b-4a90-8216-a9ecd588510a" />
<img width="1895" height="922" alt="צילום מסך 2026-06-15 215913" src="https://github.com/user-attachments/assets/55f19c19-a908-44b2-b6cb-74610543c5fa" />
<img width="1877" height="925" alt="צילום מסך 2026-06-15 215847" src="https://github.com/user-attachments/assets/4dff6477-aeb8-4074-8089-3408cc7b2d02" />
<img width="1872" height="916" alt="צילום מסך 2026-06-15 215822" src="https://github.com/user-attachments/assets/79788de6-e851-4472-ab6d-75fd49d2a40f" />
<img width="1881" height="917" alt="צילום מסך 2026-06-15 215757" src="https://github.com/user-attachments/assets/6aaa8980-8e09-47b9-a8aa-64bc1c0bdbde" />
<img width="1897" height="928" alt="צילום מסך 2026-06-15 215732" src="https://github.com/user-attachments/assets/25eb3b11-8786-45ea-9c7c-022f1cc97b87" />
<img width="1883" height="918" alt="צילום מסך 2026-06-15 215710" src="https://github.com/user-attachments/assets/5e035ff1-3106-497f-9d23-14d662673578" />
<img width="1871" height="922" alt="צילום מסך 2026-06-15 215605" src="https://github.com/user-attachments/assets/8162fac0-3c1e-4353-9528-57a20d6859a4" />
<img width="1897" height="913" alt="צילום מסך 2026-06-15 215530" src="https://github.com/user-attachments/assets/83d2e03a-c1cf-4f66-8a5d-f6a574639760" />
<img width="1888" height="917" alt="צילום מסך 2026-06-15 215505" src="https://github.com/user-attachments/assets/db898ff6-6525-4d32-a394-8baf1e71b663" />
<img width="1890" height="926" alt="צילום מסך 2026-06-15 215429" src="https://github.com/user-attachments/assets/64a74b04-5266-4bda-b7fd-e28e7d99cad9" />
<img width="1897" height="923" alt="צילום מסך 2026-06-15 215116" src="https://github.com/user-attachments/assets/e96a8f70-c70a-42f7-949c-62e4df727c29" />

