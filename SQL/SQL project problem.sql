/* 
these variables will become the row number in each of the subqueries 
*/
SET @start_row_number = 0;
SET @end_row_number = 0;

SELECT 
    Start_Date,
    End_Date
FROM(
    /* 
    Get a list of start_dates that aren't in end_date, indicating the unique dates when a project
    started, and give them a row number 
    */
    SELECT (@start_row_number:=@start_row_number + 1) AS start_num, Start_Date
    FROM Projects
    WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)
) AS Proj_Start
LEFT JOIN(
    /*
    Get a list of end_dates that aren't in start_date, indicating the unique dates when a project
    ended, and give them a row number 
    */
    SELECT (@end_row_number:=@end_row_number + 1) AS end_num, End_Date
    FROM Projects
    WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)
) AS Proj_End
/*
Because the start_date and end_date lists are unique values in sequential order, we can join them by row number. 
*/
ON start_num = end_num
ORDER BY End_Date - Start_Date asc, Start_Date asc