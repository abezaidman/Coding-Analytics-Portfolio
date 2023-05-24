-- Project Plan: A Simple Keywords Extractor

--1. Select any news/article/post on any topics. Write the web address below
--    Declaration of Independence / Tenet: Movie Review / Economic Report
--	  Also see: https://www.cortical.io/freetools/extract-keywords/

--2. Copy the whole text (Ctrl-A then Ctrl-C) 
--   Open a Notepad (or WordPad) Paste the text Ctrl-V

--3. Remove special characters (, . : ; " & ( ) / \ ! ? © etc) by Replace (Ctrl-H)'ing them with nothing.
--   Replace end of line characters (^p) with space ' ' in Word document
--   ...

--4. Save as Input.txt in your computer.

--5. Use our SandBox database to create a table

USE SandBox;
IF EXISTS(SELECT * FROM sys.objects where [type]='U' AND [name]='Input')
   DROP TABLE Input

CREATE TABLE Input(
	Word NVARCHAR(255)
);
GO

SELECT * FROM Input

--6. Populate: BULK INSERT the Input table using space as field and row terminators
BULK INSERT Input
FROM 'C:\Users\abeza\OneDrive\Desktop\SQL DATA\Input.txt'   --Your address must be different
WITH
(  --   FIRSTROW = 1
--	,FIELDTERMINATOR = ' '	
	ROWTERMINATOR = ' '
);
--we can put our table into a make-table query
SELECT * 
INTO Reseed
FROM Input
WHERE Word IS not NULL

--TRUNCATE TABLE InputTable;
SELECT * FROM Reseed;
GO

--7. Write a query to retrieve the most repeated ten words in your article
SELECT TOP (10) Word
	, COUNT(Word) AS CountOfWord
FROM Reseed
GROUP BY Word
ORDER BY CountOfWord DESC

--8. Create a table called Commons to store the most common, non-context words in English
--this common words list is subjective and can change depending on the domain and context
IF EXISTS (SELECT * FROM sys.objects WHERE [type]='U' AND [name]='Commons')
	DROP TABLE Commons
CREATE TABLE Commons(
	Word NVARCHAR(12)
);

SELECT * FROM Commons;

--9. Re-write the query in step 7. to fine tune your keywords (excluding commons)
SELECT TOP (10) Word
	, COUNT(Word) AS CountOfWord
FROM Reseed
WHERE Word NOT IN (SELECT * FROM Commons) 
GROUP BY Word
ORDER BY CountOfWord DESC

--10. Let look at the longer words (# of characters > 4)
SELECT TOP (10) Word
	, COUNT(Word) AS CountOfWord
FROM Reseed
WHERE Word NOT IN (SELECT * FROM Commons) 
AND LEN(Word) > 4
GROUP BY Word
ORDER BY CountOfWord DESC

