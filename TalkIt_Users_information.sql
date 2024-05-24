
use talkit;

# 1. How many unique profiles have been created from Jan to March
select 
distinct count(phone) as Unique_users 
from Talk_It_Users_Analysis;

# 2. Find the top 10 cities from where the users have installed the app

select city, 
count(city) as City_count
 from Talk_It_Users_Analysis
 group by city 
 order by City_Count desc limit 10;

# 3. Find the College specification of the users
select Specification_School_College_Name, 
count(Specification_School_College_Name) as Count
from Talk_It_Users_Analysis
group by Specification_School_College_Name 
order by  Specification_School_College_Name desc limit 8;

#4. From what age group maxmum number of profiles are created
select age, 
count(age) as Ages 
from Talk_It_Users_Analysis
group by Age 
order by Ages desc limit 10;

# 5. Calculate the total number of profile created gender wise
SELECT gender,
count(gender) as 
gender_count 
from Talk_It_Users_Analysis
group by gender;

#6. Calculate the total number of profile created gender wise monthly
alter table Talk_It_Users_Analysis
add updated_date date;
update Talk_It_Users_Analysis 
set updated_date = str_to_date(`time`,'%b %d, %Y');
SELECT
monthname(`updated_date`) as Month_name,
sum(case when gender="male" then 1 else 0 end )as Male,
sum(case when gender="female" then 1 else 0 end) as Female,
sum(case when gender="other" then 1 else 0 end) as `Others`
from talk_it_users_analysis
group by monthname(`updated_date`);



#7. Find the number of ios and android user on the app
select
sum(case when Device="iPhone" then 1 else 0 end) as Iphone,
sum(case when Device!="iPhone" then 1 else 0 end) as Android
from Talk_It_Users_Analysis;

#8. Find how many users have their email registered
select 
sum(case when email="undefined" then 1 else 0 end) as Not_registered,
sum(case when email!="undefined" then 1 else 0 end) as registered
from Talk_It_Users_Analysis





