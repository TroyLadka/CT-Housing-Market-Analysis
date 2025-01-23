
/* Creating a temporary table to remove unwanted columns */
CREATE TABLE ct_real_estate_clean AS
SELECT "List Year", "Date Recorded", "Town", "Address", "Assessed Value", "Sale Amount", "Sales Ratio", "Property Type", "Residential Type"
FROM ct_real_estate_1;

/* Making sure I have only the columns I need */
SELECT * FROM ct_real_estate_clean LIMIT 10;

/* Dropping the old table */
DROP TABLE ct_real_estate_1;

/* Renaming the temp table to the original table name */
ALTER TABLE ct_real_estate_clean RENAME TO ct_real_estate_1;

/* Removing all non-residential entries */
DELETE FROM ct_real_estate_1
WHERE "Property Type" NOT IN ('Single Family', 'Condo', 'Residential', 'Two Family', 'Three Family', 'Four Family', 'Apartments') OR "Property Type" IS NULL;


/* Combining the columns "Property Type" and "Residential Type" into one column titled "Type" */
ALTER TABLE ct_real_estate_1 ADD COLUMN "Type" TEXT;

UPDATE ct_real_estate_1
SET "Type" = CASE
    WHEN "Property Type" = 'Apartments' THEN "Property Type"
    ELSE "Residential Type"
END;

ALTER TABLE ct_real_estate_1 DROP COLUMN "Property Type";
ALTER TABLE ct_real_estate_1 DROP COLUMN "Residential Type";


/* Checking how many entries per year */
SELECT strftime('%Y', "Date Recorded") AS Year, COUNT(*) AS Count
FROM ct_real_estate_1
GROUP BY Year
ORDER BY Year;

/* Years before 2007 have significantly less data entries, so I am removing them */
DELETE FROM ct_real_estate_1
WHERE strftime('%Y', "Date Recorded") IN ('1999', '2001', '2002', '2003', '2004', '2005', '2006');


/* Looking at the highest recorded sales to look for outliers and potential inaccurate data */
SELECT *
FROM ct_real_estate_1
WHERE "Sale Amount" > 20000000
ORDER BY "Sale Amount" DESC;


/* Found a few sales recorded in the town of Willington that were inaccurate */
DELETE FROM ct_real_estate_1
WHERE "Sale Amount" > 20000000 AND "Town" = "Willington";


/* Making sure all town names are correct so they can be used to create a map in Tableau */
SELECT "Town", COUNT(*) AS Count
FROM ct_real_estate_1
GROUP BY "Town"
ORDER BY Count DESC;

/* Removing one entry where the town is '***Unknown***' */
DELETE FROM ct_real_estate_1
WHERE "Town" = "***Unknown***";


