SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

-- Select data we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows death percentage or likelihood of dying in a country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%singapore%'
ORDER BY 1,2

-- Looking at Total cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date,Population, 
total_cases, (total_cases/Population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%singapore%'
ORDER BY 1,2

-- Looking at Countries with highest infection rate compared to population

SELECT location,Population, MAX(total_cases) AS HighestInfectionCount, 
MAX((total_cases/Population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%singapore%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Showing Countries with highest death count per population

SELECT location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%singapore%'
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking things down by Continent

-- Showing continents with the highest death count per population

SELECT continent, MAX(CAST(total_deaths AS INT)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%singapore%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers 

SELECT sum(new_cases) AS total_cases, sum(cast(new_deaths as INT)) AS total_deaths,
sum(cast(new_deaths AS INT))/sum(new_cases)*100 as DeathPercentage
--(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
-- WHERE location like '%singapore%'
WHERE continent is not null
--GROUP BY Date
ORDER BY 1,2

-- Looking at total population vs vaccinations
-- Joining the 2 tables together

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location
ORDER BY dea.location, dea.date) as RollingPeopleVaccinated,


FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- Testing running total method

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations AS BIGINT)) OVER (ORDER BY dea.location, dea.date) as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location
ORDER BY dea.location, dea.date) as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *
FROM PopvsVac

-- Temp Table

Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)


Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.location
ORDER BY dea.location, dea.date) as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths as dea
JOIN PortfolioProject..CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- Create View to store data for later visualizations

Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location
ORDER BY dea.location, dea.date) as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--order by 

SELECT *
FROM PercentPopulationVaccinated

