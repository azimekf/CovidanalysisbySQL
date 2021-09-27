-- show data

select *
from aa..coviddata
order by 3

--select data that i want to use

select location,date,population,total_cases,new_cases,new_deaths
from aa..coviddata
where continent <>''
order by 2

--compare total case and total death

select location, date,total_cases,total_deaths,
cast(total_deaths as float)*100/(cast(total_cases as float)+0.00001)as death_percentage
from aa..coviddata
where continent <>''


--compare total case and total death in Iran
select location, date,total_cases,total_deaths,
cast(total_deaths as float)*100/(cast(total_cases as float)+0.00001)as death_percentage
from aa..coviddata
where location like '%iran%' and  continent <>'' 

--Check Total Cases vs Population
--What percent of population got covid
Select location,date, population, total_cases, cast(total_cases as float)*100/(cast(population as float)+1)
from aa..coviddata
where continent <>''

--countries with highest infection rate compare to population
Select location,population, max(total_cases) as highest_cases, max(cast(total_cases as float)*100/(cast(population as float)+1)) as highestcasesinpopulation
from aa..coviddata
where cast(population as float) <>0 and continent <>''
group by location,population
order by 4 desc

--countries with highest death rate compare to population
Select location,population, max(total_deaths) as highest_deaths, max(cast(total_deaths as float)*100/(cast(population as float)+1)) as highestdeathsinpopulation
from aa..coviddata
where cast(population as float) <>0 and continent <>''
group by location,population
order by 4 desc

--countries with highest death 
Select continent,location, max(cast(total_deaths as float)) as highest
from aa..coviddata
--where cast(population as float) <>0
where continent <>'' 
group by continent,location
order by 3 desc

--by continent
Select location, max(cast(total_deaths as float)) as highest
from aa..coviddata
where cast(population as float) <>0
and continent='' 
and location<>'world'
group by location
order by 2 desc

--global
select date,sum(cast(new_cases as float)) as total_case,
	sum(cast(new_deaths as float) )as total_death,
	(sum(cast(new_deaths as float))/(sum(cast(new_cases as float))+1))
from aa..coviddata
where continent <>''
group by date

--total population and vaccination
select date,continent,location,cast(new_vaccinations as float) as new_vac,
sum(cast(new_vaccinations as float)) over(partition by location order by location,date) as sum_vac
,cast(new_deaths as float)
from aa..coviddata
where continent <>'' and location like '%iran%'

order by 2

--Rate of vaccination in population
select location,max(sum(cast(new_vaccinations as float)))/population
from aa..coviddata
group by location

--cte
with popvsvac (continent,location,date,population,new_vaccinations,sum_vac)
as
(
select date,continent,location,cast(new_vaccinations as float) as new_vac,
sum(cast(new_vaccinations as float)) over(partition by location order by location,date) as sum_vac
,cast(new_deaths as float)
from aa..coviddata
where continent <>''
)
select *,sum_vac/(population+0.1)
from popvsvac

