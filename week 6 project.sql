-- ============================================================
-- WEEK 6: PRODUCT REVIEW AND RATING MANAGEMENT SYSTEM
-- ============================================================

USE ECommerceDB;

-- ============================================================
-- 1. CREATE REVIEW TABLE
-- ============================================================

CREATE TABLE Review (
    Review_ID VARCHAR(20) PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Rating INT NOT NULL,
    Review_Text VARCHAR(500),
    Review_Date DATE NOT NULL,

    CHECK (Rating BETWEEN 1 AND 5),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customer(Customer_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID)
        ON DELETE CASCADE
);

-- ============================================================
-- 2. INSERT REVIEW DATA
-- ============================================================

INSERT INTO Review
(Review_ID, Customer_ID, Product_ID, Rating,
 Review_Text, Review_Date)
VALUES
('R101', 1, 102, 5, 'Excellent performance', '2026-08-20'),
('R102', 1, 103, 4, 'Good quality product', '2026-08-21');

-- Display all reviews
SELECT * FROM Review;

-- ============================================================
-- 3. UPDATE AND DELETE REVIEWS
-- ============================================================

-- Update review comment
UPDATE Review
SET Review_Text = 'Excellent performance and quality'
WHERE Review_ID = 'R101';

-- Delete a review
-- DELETE FROM Review WHERE Review_ID = 'R102';

-- ============================================================
-- 4. RETRIEVE PRODUCT REVIEW DETAILS
-- ============================================================

-- 4.1 Display all reviews for products

SELECT
    Product.Product_Name,
    Review.Rating,
    Review.Review_Text
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID;

-- 4.2 Display customer name with reviews

SELECT
    Customer.Customer_Name,
    Product.Product_Name,
    Review.Rating,
    Review.Review_Text
FROM Customer
JOIN Review
ON Customer.Customer_ID = Review.Customer_ID
JOIN Product
ON Review.Product_ID = Product.Product_ID;

-- 4.3 Find products having maximum reviews

SELECT
    Product.Product_Name,
    COUNT(Review.Review_ID) AS Total_Reviews
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name
ORDER BY Total_Reviews DESC
LIMIT 1;

-- 4.4 Display recent customer feedback

SELECT
    Customer.Customer_Name,
    Product.Product_Name,
    Review.Review_Text,
    Review.Review_Date
FROM Review
JOIN Customer
ON Review.Customer_ID = Customer.Customer_ID
JOIN Product
ON Review.Product_ID = Product.Product_ID
ORDER BY Review.Review_Date DESC;

-- 4.5 Retrieve reviews with ratings above 4

SELECT *
FROM Review
WHERE Rating > 4;

-- ============================================================
-- 5. CALCULATE AVERAGE PRODUCT RATINGS
-- ============================================================

-- 5.1 Average rating for each product

SELECT
    Product.Product_Name,
    AVG(Review.Rating) AS Average_Rating
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name;

-- 5.2 Count number of reviews per product

SELECT
    Product.Product_Name,
    COUNT(Review.Review_ID) AS Total_Reviews
FROM Product
LEFT JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name;

-- 5.3 Find highest-rated products

SELECT
    Product.Product_Name,
    AVG(Review.Rating) AS Average_Rating
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name
ORDER BY Average_Rating DESC
LIMIT 1;

-- 5.4 Products with average rating above 4

SELECT
    Product.Product_Name,
    AVG(Review.Rating) AS Average_Rating
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name
HAVING AVG(Review.Rating) > 4;

-- ============================================================
-- 6. PRODUCT RATING REPORTS
-- ============================================================

-- REPORT 1: PRODUCT RATING ANALYSIS

SELECT
    Product.Product_Name,
    COUNT(Review.Review_ID) AS Number_Of_Reviews,
    ROUND(AVG(Review.Rating), 2) AS Average_Rating
FROM Product
LEFT JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name
ORDER BY Average_Rating DESC;

-- REPORT 2: MOST REVIEWED PRODUCTS

SELECT
    Product.Product_Name,
    COUNT(Review.Review_ID) AS Total_Reviews
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name
ORDER BY Total_Reviews DESC;

-- HIGHLY RATED PRODUCTS

SELECT
    Product.Product_Name,
    AVG(Review.Rating) AS Average_Rating
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name
HAVING AVG(Review.Rating) >= 4;

-- PRODUCTS REQUIRING IMPROVEMENT

SELECT
    Product.Product_Name,
    AVG(Review.Rating) AS Average_Rating
FROM Product
JOIN Review
ON Product.Product_ID = Review.Product_ID
GROUP BY Product.Product_ID, Product.Product_Name
HAVING AVG(Review.Rating) < 3;

-- REPORT 3: RATING DISTRIBUTION

-- Number of 5-star ratings

SELECT COUNT(*) AS Five_Star_Ratings
FROM Review
WHERE Rating = 5;

-- Number of 4-star ratings

SELECT COUNT(*) AS Four_Star_Ratings
FROM Review
WHERE Rating = 4;

-- Number of low ratings

SELECT COUNT(*) AS Low_Ratings
FROM Review
WHERE Rating <= 2;

-- Complete rating distribution

SELECT
    Rating,
    COUNT(*) AS Total_Reviews
FROM Review
GROUP BY Rating
ORDER BY Rating DESC;

-- ============================================================
-- END OF WEEK 6
-- ============================================================