
LOAD DATA INFILE 'C:\Documents\Data science\Analysis\C10_Input_Files\datasets'
INTO TABLE dim_match_summary
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
show tables;

create database aos;
use aos;
select* from fact_bating_summary;
alter table dim_match_summary drop column matchs;
select batsmanName, sum(runs) as totalruns from fact_bating_summary
group by batsmanName 
Order by sum(runs) desc limit 10;

select b.batsmanName , (sum(b.runs)/sum(b.balls))*100 as strike_rate
from fact_bating_summary as b , dim_match_summary as m
where m.match_id=b.match_id
group by b.batsmanName
HAVING SUM(CASE WHEN year(m.matchDate) = 2023 THEN b.balls END) >= 60
   AND SUM(CASE WHEN year(m.matchDate) = 2022 THEN b.balls END) >= 60
   AND SUM(CASE WHEN year(m.matchDate) = 2021  THEN b.balls END) >= 60
ORDER BY strike_rate DESC
limit 10;

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE fact_bating_summary ADD out_not varchar(50);
UPDATE fact_bating_summary SET out_not = `out/not_out`;
SET SQL_SAFE_UPDATES = 1;

select b.batsmanName, sum(b.runs)/ NULLIF(SUM(CASE WHEN b.out_not = 'out' THEN 1 ELSE 0 END), 0)as batting_average
from fact_bating_summary  as b 
JOIN dim_match_summary AS m ON b.match_id = m.match_id
group by b.batsmanName
HAVING SUM(CASE WHEN year(m.matchDate) = 2023 THEN b.balls END) >= 60
   AND SUM(CASE WHEN year(m.matchDate) = 2022 THEN b.balls END) >= 60
   AND SUM(CASE WHEN year(m.matchDate) = 2021  THEN b.balls END) >= 60
ORDER BY batting_average DESC
limit 10;

select bowlerName, sum(wickets) as wickets
from fact_bowling_summary
group by bowlerName
order by wickets desc limit 10;

select b.bowlerName, sum(b.runs)/ sum(b.wickets) as bowling_average
from fact_bowling_summary as b, dim_match_summary as m
where m.match_id=b.match_id
group by b.bowlerName
HAVING SUM(CASE WHEN year(m.matchDate) = 2023 THEN b.overs END) >= 10
   AND SUM(CASE WHEN year(m.matchDate) = 2022 THEN b.overs END) >= 10
   AND SUM(CASE WHEN year(m.matchDate) = 2021  THEN b.overs END) >= 10
   order by bowling_average limit 10;
 
select b.bowlerName , sum(b.runs)/sum(b.overs)  as economy
from fact_bowling_summary as b, dim_match_summary as m
where b.match_id=m.match_id
group by b.bowlerName
HAVING SUM(CASE WHEN year(m.matchDate) = 2023 THEN b.overs END) >= 10
   AND SUM(CASE WHEN year(m.matchDate) = 2022 THEN b.overs END) >= 10
   AND SUM(CASE WHEN year(m.matchDate) = 2021  THEN b.overs END) >= 10
   order by economy limit 10;
 select*from fact_bating_summary;

select b.bowlerName , (sum(b. 0s)/sum(b.overs*6))*100 as dotballs
from fact_bowling_summary as b, dim_match_summary as m
where b.match_id=m.match_id
group by b.bowlerName
HAVING SUM(CASE WHEN year(m.matchDate) = 2023 THEN b.overs END) >= 10
   AND SUM(CASE WHEN year(m.matchDate) = 2022 THEN b.overs END) >= 10
   AND SUM(CASE WHEN year(m.matchDate) = 2021  THEN b.overs END) >= 10
order by dotballs desc limit 5;

select bowlerName, sum(maiden) as Maiden_Overs
from fact_bowling_summary
group by bowlername
order by Maiden_Overs desc limit 5;

select team1 , (count(team1)+count(team2)) 
from dim_match_summary
group by team1;

SELECT TeamName, 
       COUNT(*) AS TotalPlayed, SUM(CASE WHEN winner = TeamName THEN 1 ELSE 0 END) AS TotalWins
FROM (
    SELECT team1 AS TeamName, winner
    FROM dim_match_summary
    UNION ALL
    SELECT team2 AS TeamName, winner
    FROM dim_match_summary
) AS AllTeams 
GROUP BY TeamName;

select winner as team, count(winner) as winning_times
from dim_match_summary
group by winner
order by winning_times desc ;

select b.batsmanName, (sum(b. 6s*6)+ sum(b. 4s*4))/sum(b.runs) as total
from fact_bating_summary as b, dim_match_summary as m
where b.match_id= m.match_id
group by b.batsmanName
HAVING SUM(CASE WHEN year(m.matchDate) = 2023 THEN b.balls END) >= 60
   AND SUM(CASE WHEN year(m.matchDate) = 2022 THEN b.balls END) >= 60
   AND SUM(CASE WHEN year(m.matchDate) = 2021  THEN b.balls END) >= 60
order by total desc limit 5;



















