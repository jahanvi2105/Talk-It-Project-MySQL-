use talkit;
# 1. Find the number of talks done in each gender combination
select
sum( case when gender="male" and Callee_Gender="male" then 1 else 0 end) as Male_to_Male,
sum( case when gender="Female" and Callee_Gender="Female" then 1 else 0 end) as Female_to_Female,
sum( case when gender="male" and Callee_Gender="Female" then 1 else 0 end) as Male_to_Female,
sum( case when gender="Female" and Callee_Gender="male" then 1 else 0 end) as Female_to_male
from Talk_Durations_Analysis;

# 2. Find the number of talks done by different gender combinations each month

select monthname(modified_date1) as Month_Name,
sum( case when gender="male" and Callee_Gender="male" then 1 else 0 end) as Male_to_Male,
sum( case when gender="Female" and Callee_Gender="Female" then 1 else 0 end) as Female_to_Female,
sum( case when gender="male" and Callee_Gender="Female" then 1 else 0 end) as Male_to_Female,
sum( case when gender="Female" and Callee_Gender="male" then 1 else 0 end) as Female_to_male
from Talk_Durations_Analysis
group by monthname(modified_date1);

# 3. Find the chat duration between different gender combinations that is Male to Male, Female to Female, Male to Female
select 
sum(case when Gender="Male" and  Callee_Gender="Female" then chat_duration/3600 else 0 end) as Male_to_Female,
 sum(case when Gender="Female" and  Callee_Gender="male" then chat_duration/3600 else 0 end) as Female_to_female,
 sum(case when Gender="Female" and  Callee_Gender="Female" then chat_duration/3600 else 0 end) as Female_to_Female,
 sum(case when Gender="Male" and  Callee_Gender="Male" then chat_duration/3600 else 0 end) as  Male_to_male
 from talk_durations_analysis;
 
 /*Conclusion: From the above query a discrepency was observed.
  Male to Female Total_Chat Duration is different from Female to Male Chat Duration which is not logical.
  To understand the reason behind this I ran the query below*/
 
SELECT 
`date`,`Name`, gender, callee_gender, chat_id,
COUNT(chat_id) AS chatid_count,chat_duration
FROM Talk_Durations_Analysis where chat_id not like '%0000'
GROUP BY
chat_id,`Name`, `Date`, gender, callee_gender, chat_duration
order by chat_id desc;

/*Conclusion: From the result of above query I found out many discrepencies*/
/*In many cases there is only 1 chat_id where as there should be same chat_ids for 2 users (caller1 and caller 2 on the same call)*/
/*In many cases there were different chat durations for both the users talking which is not logical. This helped us to understand that there is a discrepency- 
 in the call recordings. After reporting this a thorough testing was done by the back end team to find the reasons for this*/
/*There were more than 2 chat ids generated in many cases*/
/*To filter this out further I ran the query given below
The query displays the calls where chat duration is not the same on both the ends*/

SELECT
chat_id,
`Name`,
chat_duration
FROM Talk_Durations_Analysis
WHERE
chat_id IN (
        SELECT
		chat_id
        FROM Talk_Durations_Analysis
		where
		chat_id not like '%0000'
        GROUP BY chat_id
        HAVING COUNT(*) = 2
		AND COUNT(DISTINCT chat_duration) > 1
    ) 
ORDER BY
chat_id, `Name` asc;


## To run QUERY 4 I encountered a problem
## Here the problem was that I forgot to add the User_Type column in the table TALK_DURATION_ANALYSIS
##So I had to add a new column named Type_of_Users. 
## So I imported the table User_types ,I showed Type_of _User= "ambassadors"for all the ambassdors and for the remaining users i showed Type_of_User="regular"
##I was not able to use join function as there was not any common key in both the tables that would help me join both the tables.

alter table Talk_Durations_Analysis
add column Type_of_column text;
UPDATE Talk_Durations_Analysis
SET `Type_of_User` = 
    CASE
        WHEN `Name` IN (
            'Ganga Arora','Jazz Nazz','Komalpreet Kaur','Jyoti Singh','Suma Kiran','Nayana Sharma','Charu Lal','Saira Perwin',
            'Preety Kumari','Prerna Narang','Srishti Sachdeva Bhatia','Suma Kiran','Shnaya Divakar','Pranjali Chavhan','Ashima Talwar','Deepika Choudhary',
		    'Ishika Gill','Rupali Raut','Himanshi Chanchlani','Shiropa Ghosh','Sakshi Kashyap','Fiza Shekh','Beulah Beautiful','Reemsha Khan',
            'Harshada Chavan','Ishita Sinh','Honey Bee','Neha Choudhary','Divyanka Divyanka Shukla','Mehvish Fatima','Nidhi Omer','Jupitara Chakpram','Ikra Khan',
			'Nandini Singh','Shruti Jain','Anamika Thakur','Sakshi Gupta','Amisha Paul','Serene !','Kajal Dwivedi','Niti .','Annie V',
            'Divya Divya Sharma','Laxmipriya Mishra','Priya Yadav','Sneha Madaan','Manisha Manisha','Pratibha Munakhia','Mahima Rajput',
            'Lavisha Sehra','Swati Suman','Chetna Kohli','Tisha Arora','Shivani Kadambari','Khushboo Targotra','Khushi Sharma','Amrita Yadav',
            'Garima Jain','Pravallika Kuchipudi','Vanshika Soner','Chandni Beniwal','Jyoti Tripathi','Suma Kiran','Ash Tiwari',
            'Monika Monika','Shreyu 09','Pritika Mittal','Jyoti Prasad','Hansika Bhutani','Aastha Bathre','Ammie Xoxo','Saumya Chand',
            'Kunal Arora','Jazz Kaur','Rakhi Krishna','Smriti Smriti Jaiswal','Kajalpreet Kaur','Sweta Sethi','Aanya Roy','Jyoti Thakur','Ruby Gagguturi','Simrein S','Pragya Pragya Kumari','Mahima Agarwal','Aishwarya Ghodke',
            'Swaranjali Roy','Shalu Rajput','Jyoti Singh','Vanshika Soner','Dharmendra Kumar Rajan','Priyanka Tiwari','Manisha Manisha',
            'Astha Thapa','Queen Jalmulak','Amatulla Sethjiwala','Aryaman Mutneja','Ritu Meena','Sana Rawat','Nandini Chandela',
            'Amit Thakor','Muskan Rajput','Akanksha Gadge','Moon Child','Bhavneet Kour','Vanshika Panwar','Shreya B','Babli Khatoon',
            'Neetu Choudhary','Pooja Gupta','Tanya San','Shreya Mishra','Jasmeet Kaur','Kittu .','Anisha Gupta','Sneha Chopra','Lovneet Saini',
            'Queen Queen','Anjali Tiwari','Khushi Gupta','Mehak Agarwal','Vanshika Agarwal','Anshika Soni','Venkatalakshmi B K','Priyanka Khurana',
            'Manisha Singh','Yukta Sadana','Sneha Rani','Bhumika Sharma','Nasaralis Dkhar','Diya Singla','Vanshika Khurana'
        )
        THEN 'Ambassador'
        ELSE 'Regular'
    END;


# 4. Find the top 3 regular users from each month
select
Month_of_talk,
`Name`,
`rank`
from
(
select `Name`, monthname(modified_date1) as Month_of_Talk, sum(chat_duration) as Total_Chat_duration,
rank() over(partition by monthname(modified_date1) order by sum(chat_duration) desc) as `rank`
from Talk_Durations_Analysiswhere 
where Type_of_user ="Regular"
group by `Name`, monthname(modified_date1)
)
as ranked_data 
where `rank`<=3 ;


# 5. Find the sum of chat duration by males and females monthly

select monthname(modified_date1),
round(sum(case when gender="Male" then chat_duration/3600 else 0 end),2) as Monthly_Male_chat_duration,
round(sum(case when gender="Female" then chat_duration/3600 else 0 end),2) as Monthly_Female_chat_duration
from Talk_Durations_Analysis
group by monthname(modified_date1)
order by monthname(modified_date1) desc;

#6. Find out how may users had the chat duration between 0-600 seconds with aninterval size of 60
select
case when chat_duration between 0 and 60 then '0-60'
when chat_duration between 60 and 120 then '60-120'
when chat_duration between 120 and 180 then '120-180'
when chat_duration between 180 and 240 then '180-240'
when chat_duration between 240 and 300 then '240-300'
when chat_duration between 300 and 600 then '300-600'
else '600 above'
end as `Intervals_of_chat`,
count(*) as Talk_Count from Talk_Durations_Analysis
group by Intervals_of_chat
order by Intervals_of_chat;








