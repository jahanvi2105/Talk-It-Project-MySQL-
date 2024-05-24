/* Ambassadors were the females that were hired by our company to engage with the users ( talk with the male users specifically) on the app.
The ratio of male to females is 16:9 .So we needed more females to engage with males on the app. That is why female ambassadors were hired.*/


##AMBASSADORS PERFORMANCE

# 1. Find the total number of ambassadors on the app in the last 3 months
select count( distinct`Name`) as Ambassadors_count from Talk_Durations_Analysis where Type_of_user="Ambassador";

# 2.  Arrange the ambassadors in the order of their activeness on the app from Jan to March
select `Name`, 
sum(chat_duration)/3600 as Total_Chat_Duration_hours
from Talk_Durations_Analysis
where Type_of_user="Ambassador" 
group by `Name`
order by Total_Chat_Duration desc;

# 3. Make a table to find and compare the performance of the Ambassadors monthwise
select `Name`,
sum(case when month(modified_date1)=01 then chat_duration/3600 else 0 end) as January_Chat_Duration,
sum(case when month(modified_date1)=02 then chat_duration/3600 else 0 end) as Feburary_Chat_Duration,
sum(case when month(modified_date1)=03 then chat_duration/3600 else 0 end) as March_Chat_Duration
from Talk_Durations_Analysis
where Type_of_user="Ambassador"
group by `Name`
order by `Name`;

# 4. Find the total talk duration done by ambassadors daily
select modified_date1, 
round(sum(chat_duration)/3600,2) as Total_chat_duration
from Talk_Durations_Analysis
where Type_of_user="Ambassador"
group by modified_date1 
order by modified_date1 asc;

# 5. FInd the sum of talk_duration done by ambassadors weekly
select modified_date1, 
round(sum(chat_duration)/3600,2) 
from Talk_Durations_Analysis
where Type_of_user="Ambassador"
 group by modified_date1 
 order by modified_date1 asc;


# 6. Find the average talk duration for Regular Users, Ambassadors and overall daily
select
modified_date1,
round(avg(case when Type_of_user="Regular" then chat_duration/60 end),2) as Avg_chat_Regular,
round(avg(case when Type_of_user="Ambassador" then chat_duration/60 end),2) as Avg_chat_Ambassadors,
round(avg(chat_duration/60 ),2) as Avg_chat_Overall
from Talk_Durations_Analysis
group by modified_date1
order by modified_date1 asc;

# 7. Find the average talk duration for Regular Users, Ambassadors and overall monthwise
select monthname(modified_date1),
round (avg(case when Type_of_user= "Regular" then chat_duration/60 end),2) as Avg_chat_Regular,
round (avg(case when Type_of_user= "Ambassador" then chat_duration/60 end),2) as Avg_chat_Ambassador,
round (avg( chat_duration/60 ),2) as Avg_chat_Overall
from
Talk_Durations_Analysis
group by monthname(modified_date1)
order by monthname(modified_date1) asc;


# 8. Find the sum of chat duration done by Regular Users, Ambassadors and overall monthwise
select 
monthname(modified_date1),
round(sum(case when Type_of_User="Regular" then chat_duration/3600 else 0 end),2) As Regular_Talk_Duration,
round(sum(case when Type_of_User="Ambassador" then chat_duration/3600 else 0 end),2) As Ambassador_Talk_Duration,
round(sum(chat_duration/3600),2)As Overall_Talk_Duration
from Talk_Durations_Analysis
group by monthname(modified_date1)
order by monthname(modified_date1)asc;

# 9. Find the chat duration between males to ambassadors and female to ambassadors
select modified_date1,
round(sum(case when Callee_Gender="Male" and Type_of_User="Ambassador" then chat_duration/3600 else 0 end),2) as Chat_Male_to_Amb_hours,
round(sum(case when Callee_Gender="Female" and Type_of_User="Ambassador" then chat_duration/3600 else 0 end),2) as Chat_Female_to_Amb_hours
from Talk_Durations_Analysis
group by modified_date1
order by modified_date1 asc;












