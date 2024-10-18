select * from dbo.CovidDeaths

select * from dbo.CovidVaccinations

SELECT location, date, total_cases, new_cases, total_deaths, new_deaths, population
from dbo.CovidDeaths
order by 1, 2


--Death count from Covid in the US from 2020-2021
SELECT location, date, total_cases, total_deaths, round(((total_deaths/total_cases)*100),2) as DeathPercentage
from dbo.CovidDeaths
where continent is not null
and location not in ('World', 'European Union', 'International')

order by 1, 2


----sumtotal death rate till 2021
SELECT sum(new_cases) as cases, sum(new_deaths) as deaths, round(((sum(new_deaths)/sum(new_cases))*100),2) as deathPercentage
from dbo.CovidDeaths
where continent is not null
and location not in ('World', 'European Union', 'International')


---deathrate  in each country(Tableau)
SELECT location, sum(new_deaths) as DeathCount, sum(new_cases) as InfectionCount, ((sum(new_deaths)/sum(new_cases))*100) as DeathRate
from dbo.CovidDeaths
where continent is not null
and location not in ('World', 'European Union', 'International')
GROUP by population, location 
order by DeathRate DESC

-- infectionrate in each country(tableau)
SELECT location, population, date, max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
from dbo.CovidDeaths
where continent is not null
and location not in ('World', 'European Union', 'International')
GROUP by location, population, date
order by PercentPopulationInfected DESC



---deathcount by continent
SELECT location, sum(new_cases) as InfectionCount ,sum(new_deaths) as DeathCount
from dbo.CovidDeaths
where continent is null
and location not in ('World', 'European Union', 'International')
GROUP by location
order by 1

--------------------------
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.CovidDeaths

where continent is not null
and location not in ('World', 'European Union', 'International')
Group by Location, Population
order by PercentPopulationInfected desc





SELECT dea.location, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (PARTITION by dea.location order by dea.date) as RollingVaccinationSum, 
dea.population
from dbo.CovidVaccinations vac join dbo.CovidDeaths dea on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null 
and dea.location not in ('World', 'European Union', 'International')



--vaccination sum
SELECT dea.location,
SUM(vac.new_vaccinations) as vaccinationTotal,
dea.population
from dbo.CovidVaccinations vac join dbo.CovidDeaths dea on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null 
and dea.location not in ('World', 'European Union', 'International')
group by dea.location, dea.population
order by 1


CREATE VIEW vw_RollingVaccinationDeathRates AS
with RollingPeopleVaccination as (
SELECT dea.location, dea.date, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (PARTITION by dea.location order by dea.date) as RollingVaccinationSum, 
population,
dea.new_deaths, sum(dea.new_deaths) over (PARTITION by dea.location order by dea.date) as RollingDeathSum,
dea.new_cases,
sum(dea.new_cases) over (PARTITION by dea.location order by dea.date) as RollingNewCases
from dbo.CovidVaccinations vac join dbo.CovidDeaths dea on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null 
)

select *,
CONVERT(float, RollingDeathSum)/RollingNewCases*100 As DeathRate from RollingPeopleVaccination


select * from dbo.vw_RollingVaccinationDeathRates
order by 1,2
----------------------------------------------------------
--test and positive rate and median age in each country 
---age and diabetes and smoke and handwashing and hdi index in covid rate abd icu_patients
--reproduction rate

select location, median_age, sum(new_tests) As totaltestcount, avg(positive_rate) as positivityRate, population_density, handwashing_facilities, diabetes_prevalence,
aged_65_older, aged_70_older
from dbo.CovidDeaths
where continent is not null
and location not in ('World', 'European Union', 'International')
GROUP by location, median_age,population_density, handwashing_facilities,diabetes_prevalence,aged_65_older, aged_70_older
ORDER by 1


