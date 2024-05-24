#1. Find the total number of Application Installed, Profile created and Conversion percentage from App Installed to Profile created from Jan to March
select
 (select sum(`Application Installed [Unique Users]`) from `events_daywise`) as Application_installed,
 (select sum(`Profile_Created [Unique Users]`) from `events_daywise`) as Profile_created,
 (select round(sum(`Profile_Created [Unique Users]`)*100/sum(`Application Installed [Unique Users]`),2) from events_daywise) as Conversion_Percentage;

# 2. Calculate the total number of App_installed, Profile_created, Conversion_rate monthwise
select
monthname(new_date) as Months,
sum(`Application Installed [Unique Users]`) as Monthly_App_installed,
sum(`Profile_Created [Unique Users]`) as Monthly_Profile_created,
round(sum(`Profile_Created [Unique Users]`)*100/sum(`Application Installed [Unique Users]`),2) as Monthly_conversion
from events_daywise
group by monthname(new_date);

#3 Find the number of user active monthwise
select 
monthname(new_date) as Months, 
sum(`application_opened[unique users]`) as App_opened from events_daywise group by monthname(new_date);

# 4.  Find out how many events and unique users clicked on Master_Talk Screen Searching monthly
select 
monthname(new_date) as Months, 
sum(`Master_Talk_Screen_Searching [Total Events]`) as Total_Sum, 
sum(`Master_Talk_Screen_Searching [Unique Users]`) as Unique_sum 
from events_daywise  group by monthname(new_date);


#5.  Find out how many users clicked on Master_Talk Screen Searching weekly
select week(new_date) as Week_No, 
sum(`Master_Talk_Screen_Searching [Total Events]`), 
sum(`Master_Talk_Screen_Searching [Unique Users]`)
from events_daywise 
group by Week_No;

#6. Find the conversion of users who opened the app to how many actually talked
select 
new_date,
`application_opened[unique users]`, 
`Talk_It_Chat_Started [Unique Users]`,
round(`Talk_It_Chat_Started [Unique Users]`*100/`application_opened[unique users]`,2)as Conversion
from events_daywise;


#7.  Find the  average conversion of users who opened the app to how many actually talked
select avg(`Talk_It_Chat_Started [Unique Users]`*100/`application_opened[unique users]`) as Average
from
(
select 
new_date,
`application_opened[unique users]`, `Talk_It_Chat_Started [Unique Users]`,
(`Talk_It_Chat_Started [Unique Users]`*100/`application_opened[unique users]`)as Conversion
 from events_daywise
) as a;

# 8 Find out on which day of the week maximumu users opened the Application. Do you see any pattern?
select `day`,count(`Day`)
from
(
select `Day`,Week_no, max(Application_opened) 
from 
(
select dayname(new_date) as `Day` ,week(new_date) as Week_no, sum(`application_opened[unique users]`)as Application_opened,
rank() over(partition by week(new_date) order by sum(`application_opened[unique users]`)desc) as Max_OPened
from events_daywise 
group by dayname(new_date),week(new_date)
) as b 
 where Max_OPened=1
 group by `day`,week_no
 ) as a
 group by `day`;
 
 
 #9 Find out on which day of the week maximumu users did Talk it chat started event. Do you see any pattern?
 select `day`,count(`day`) as Number_of_days
 from
 (
 select `Day`,Week_no, max(Talk_it_chat_started) 
from 
(
select dayname(new_date) as `Day` ,week(new_date) as Week_no, sum(`Talk_It_Chat_Started [Total Events]`)as Talk_it_chat_started,
rank() over(partition by week(new_date) order by sum(`Talk_It_Chat_Started [Total Events]`)desc) as Max_OPened
from events_daywise 
group by dayname(new_date),week(new_date)
) as b 
 where Max_OPened=1
 group by `day`,week_no
 )as a
 group by `day`
 order by count(`day`) desc;
 
 # 10 Find on which day the maximum chat duration is done
 select `day`,count(`day`) as Number_of_weeks 
 from
 (
 select `Day`,Week_no, max(Total_Chat_duration) 
from 
(
select dayname(modified_date1) as `Day` ,week(modified_date1) as Week_no, sum(Chat_Duration)as Total_Chat_duration,
rank() over(partition by week(modified_date1) order by sum(chat_duration) desc) as Max_Chat_duration
from `mummm - copy`
group by dayname(modified_date1),week(modified_date1)
) as b 
 where Max_Chat_duration=1
 group by `day`,week_no
 )as a
 group by `day`
 order by count(`day`) desc;
 
 
 # 11.  Find the number of talks done in each gender combination
select
sum( case when gender="male" and Callee_Gender="male" then 1 else 0 end) as Male_to_Male,
sum( case when gender="Female" and Callee_Gender="Female" then 1 else 0 end) as Female_to_Female,
sum( case when gender="male" and Callee_Gender="Female" then 1 else 0 end) as Male_to_Female,
sum( case when gender="Female" and Callee_Gender="male" then 1 else 0 end) as Female_to_male
from `mummm - copy`;


 


 



 