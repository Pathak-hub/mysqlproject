SELECT *
FROM [portfolio project]..CovidDeaths$
order by 3,4

SELECT *
FROM [portfolio project]..CovidDeaths$
order by 3,4
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM [portfolio project]..CovidDeaths$
order by 1,2


SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as fatality_percentage
FROM [portfolio project]..CovidDeaths$
Where location like '%india%'
order by 1,2

SELECT location,date,total_cases,total_deaths,population,(total_cases/population)*100 as infection_percentage
from [portfolio project]..CovidDeaths$
--where location like '%india%'
order by 1,2

SELECT location,total_cases,population,(total_cases/population)*100 as infection_rate
from [portfolio project]..CovidDeaths$
order by infection_rate desc


SELECT location,Population, MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as infection_rate
from [portfolio project]..CovidDeaths$
Group by Location,Population
order by infection_rate desc

--countries wit max deats
SELECT location , MAX(cast(total_deaths as int)) as totaldeathcount
from [portfolio project]..CovidDeaths$
where continent is not null
group by location
order by totaldeathcount desc

SELECT continent , MAX(cast(total_deaths as int)) as totalfatality
from [portfolio project]..CovidDeaths$
where continent is not null
group by continent
order by totalfatality desc

SELECT location , MAX(cast(total_deaths as int)) as totalfatality
from [portfolio project]..CovidDeaths$
where continent is  null
group by location
order by totalfatality desc

SELECT date,total_cases,total_deaths,(total_deaths/total_cases)*100 as fatality
from [portfolio project]..CovidDeaths$
order by 1,2

SELECT date,sum(new_cases) as total
from [portfolio project]..CovidDeaths$
group by date
order by total desc

SELECT date ,sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_fatality
from [portfolio project]..CovidDeaths$
where continent is not null
group by date
order by 1,2

SELECT date , sum(new_cases) as total_cases , sum(cast(new_deaths as int )) as total_fatality , sum(cast(new_deaths as int))/sum(new_cases) as fatality_ratio
from [portfolio project]..CovidDeaths$
where continent is not null
group by date
order by fatality_ratio desc

SELECT *
from [portfolio project]..CovidDeaths$ cd
join [portfolio project]..CovidVaccinations$ cv
  On cd.location = cv.location
  and cd.date = cv.date

SELECT cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
from [portfolio project]..CovidDeaths$ cd
join [portfolio project]..CovidVaccinations$ cv
 On cd.location = cv.location
 and cd.date = cv.date
 where cd.continent is not null
 --order by 1,2,3

  Select cd.continent,cd.location,cd.date,cd.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) over (Partition by cd.location order by cd.location,cd.Date) as vaccinated
 from [portfolio project]..CovidDeaths$ cd
 join [portfolio project]..CovidVaccinations$ vac 
   On cd.location = vac.location
   and cd.date = vac.date
   where cd.continent is not null
   order by 2,3




 With PopvsVac(Continent,Location,Date,Population,New_Vaccinations,totalvaccinations)
 as
 (
 SELECT cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,sum(cast(cv.new_vaccinations as int)) over (partition by cv.new_vaccinations order by cv.location ) as totalvaccinations
from [portfolio project]..CovidDeaths$ cd
join [portfolio project]..CovidVaccinations$ cv
 On cd.location = cv.location
 and cd.date = cv.date
 where cd.continent is not null
 --order by 2,3
 )
 Select * ,(totalvaccinations/Population)*100
 From PopvsVac

Drop table if exists #percantvaccinatad
 Create Table #percantvaccinatad
 (
 continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 new_vaccinations numeric,
 totalvaccinated numeric
 )

 insert into #percantvaccinatad
 Select cd.continent,cd.location,cd.date,cd.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) over (Partition by cd.location order by cd.location,cd.Date) as vaccinated
 from [portfolio project]..CovidDeaths$ cd
 join [portfolio project]..CovidVaccinations$ vac 
   On cd.location = vac.location
   and cd.date = vac.date
   where cd.continent is not null
   order by 2,3
 Select *
 From #percantvaccinatad

 --Create view  #percantvaccinated as
 --Select cd.continent,cd.location,cd.date,cd.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) over (Partition by cd.location order by cd.location,cd.Date) as vaccinated
 --from [portfolio project]..CovidDeaths$ cd
 --join [portfolio project]..CovidVaccinations$ vac 
 --  On cd.location = vac.location
 --  and cd.date = vac.date
  -- where cd.continent is not null

  --create view 
  --Drop table if exists #PercentageVaccinated
  CREATE view PercentageVaccinated as
  Select cd.continent,cd.location,cd.date,cd.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int)) over (Partition by cd.location order by cd.location,cd.Date) as vaccinated
 from [portfolio project]..CovidDeaths$ cd
 join [portfolio project]..CovidVaccinations$ vac 
   On cd.location = vac.location
   and cd.date = vac.date
   where cd.continent is not null
   --order by 2,3
