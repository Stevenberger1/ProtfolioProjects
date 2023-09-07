-- Looking for Total cases vs Total deaths
-- Likelihood of dying if you contract covid in israel 
SELECT
    Location,
    date,
    total_cases,
    total_deaths,
    CASE
        WHEN total_cases = 0 THEN 0
        ELSE (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100
    END AS DeathPrecentage
FROM
    [Protfolioproject- corona vairus]..CovidDeaths
where location like '%israel%'
and continent is not null
ORDER BY 1,2;


-- Looking at Total cases vs Population
-- Shows what percentage of population got covid
SELECT
    Location,
    date,
    total_cases,
    population,
    CASE
        WHEN total_cases = 0 THEN 0
        ELSE (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100
    END AS InfectedPrecentage
FROM
    [Protfolioproject- corona vairus]..CovidDeaths
where location like '%israel%'
and continent is not null
ORDER BY 1,2;

--Looking at Countries with Highest infeciton rate compared ot population

SELECT
    Location,
    population,
    MAX(total_cases) as HighestInfectionCount,
    MAX((total_cases/population))*100 as PercentPopulationInfected
FROM
    [Protfolioproject- corona vairus]..CovidDeaths
where continent is not null
GROUP BY Location, population
ORDER BY PercentPopulationInfected desc;


-- Showing Counties with highest death count per population		
SELECT
    Location,max(cast(total_deaths as int)) as TotalDeathCount
FROM
    [Protfolioproject- corona vairus]..CovidDeaths
where continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc;



-- Showing continent with highest deaths
SELECT
    continent,max(cast(total_deaths as int)) as TotalDeathCount
FROM
    [Protfolioproject- corona vairus]..CovidDeaths
where continent is not null
GROUP BY  continent
ORDER BY TotalDeathCount desc;


-- Showing continents with the highest death count per population
SELECT
    continent,max(cast(total_deaths as int)) as TotalDeathCount
FROM
    [Protfolioproject- corona vairus]..CovidDeaths
where continent is not null
GROUP BY  continent
ORDER BY TotalDeathCount desc;

-- GLOBAL NUMBERS
SELECT
    date,SUM(new_cases) as total_cases ,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPerecntage

FROM
    [Protfolioproject- corona vairus]..CovidDeaths
where continent is not null
group by date
ORDER BY 1,2;



-- Looking at total population vs vaccinations
with PopvsVac(Continent,Location,date,population,new_vaccinations,RollingPepoleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) Over(partition by dea.location order by dea.location,
dea.date) as RollingPepoleVaccinated
from [Protfolioproject- corona vairus]..CovidDeaths dea 
join [Protfolioproject- corona vairus]..CovidVacinations vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null

)
select*,(RollingPepoleVaccinated/population)*100
from PopvsVac

--TEMP TABLE
Drop table if exists  #PercentpopulationVaccianted

create table #PercentpopulationVaccianted(
Continent nvarchar(255),location nvarchar(255),Date datetime,population numeric,
new_vaccinations numeric,RollingPepoleVaccinated numeric)

Insert into #PercentpopulationVaccianted
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) Over(partition by dea.location order by dea.location,
dea.date) as RollingPepoleVaccinated
from [Protfolioproject- corona vairus]..CovidDeaths dea 
join [Protfolioproject- corona vairus]..CovidVacinations vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null

select*,(RollingPepoleVaccinated/population)*100
from  #PercentpopulationVaccianted




USE [Protfolioproject- corona vairus]; -- This sets the database context
GO


CREATE VIEW  [dbo].[PercentpopulationVaccianted] AS
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) Over(partition by dea.location order by dea.location,
dea.date) as RollingPepoleVaccinated
from [Protfolioproject- corona vairus]..CovidDeaths dea 
join [Protfolioproject- corona vairus]..CovidVacinations vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null




USE [Protfolioproject- corona vairus]; -- This sets the database context
GO

CREATE VIEW [dbo].[HighestDeathPerPopulation] AS
SELECT
    continent,
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
    dbo.CovidDeaths  -- Assuming the table is in the 'dbo' schema
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent;


select * from HighestDeathPerPopulation	