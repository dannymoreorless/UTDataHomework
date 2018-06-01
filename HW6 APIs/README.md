
# Weatherpy

## Analysis
* As shown in the Max Temperature vs. Latitude Plot, one can clearly see that the temperature recorded in cities gradually reaches a peak as one travels from one pole of the planet to the other; in other words, the planet is warmer along its equator.
* Upon analysis of the Wind Speed and Cloudiness, it would seem that there is little to no correlation between Latitude and Wind Speed or Cloudiness. However, it would appear that towards the equator, there is more moisture in the air, as shown in the Humidity vs. Latitude Plot. When examining the plot, there is almost always a gap near the equatorial Latitude (0) on the scatter plot due to cities on, or near, the equator having high humidity.
* One issue with this method of analysis is that not all cities have data collected from the openweathermap api and as a result, one should have a buffer zone of approximately 100 for a sample size of 500. To resolve this, one could generate cities and call their data while simultaneously checking if the city exists in the database. From there a flag could be raised and an if-else construct could be used to filter out the cities that don't have data and replace them with one that does.


```python
from citipy import citipy
import random
import matplotlib.pyplot as plt
import openweathermapy as ow
import pandas as pd
from configweather import api_key
```

## Generate Cities List
Something to keep in mind when doing this analysis was the distribution of land, and therefore cities, on the planet. For example, Earth is very "top-heavy" in the sense that "land areas are distributed predominantly in the Northern Hemisphere (68%) relative to the Southern Hemisphere (32%) as divided by the equator" (http://phl.upr.edu/library/notes/distributionoflandmassesofthepaleo-earth). A similar behavior is exhibited when comparing the Eastern and Western Hemispheres as well, with the East having nearly double that of the West. This can create a skewed analysis due to the fact that a majority of cities would be expected to be in the hemispheres with the greatest amount of land. I've combatted this bias by implementing a simple "if-elseif" construct to sample the 4 quadrants of the world for cities.

To avoid duplicate cities, I've implemented an if-statement which checks if the newly generated city is already in the cities list, if so it won't append the duplicate to the list.


```python
cities = []
samplesize = 700

def generate_cities(sample_size):
    i = 0
    while(i < samplesize):
        if i < (samplesize/4) :
            lat = (random.randint(-90,0)) + (random.randint(0,10)/10) + (random.randint(0,10)/100) 
            lon = (random.randint(-180,0)) + (random.randint(0,10)/10) + (random.randint(0,10)/100)
        elif i < (samplesize/2):
            lat = (random.randint(0,90)) + (random.randint(0,10)/10) + (random.randint(0,10)/100) 
            lon = (random.randint(-180,0)) + (random.randint(0,10)/10) + (random.randint(0,10)/100)
        elif i < (samplesize*(3/4)):
            lat = (random.randint(-90,0)) + (random.randint(0,10)/10) + (random.randint(0,10)/100) 
            lon = (random.randint(0,180)) + (random.randint(0,10)/10) + (random.randint(0,10)/100)
        else:
            lat = (random.randint(0,90)) + (random.randint(0,10)/10) + (random.randint(0,10)/100) 
            lon = (random.randint(0,180)) + (random.randint(0,10)/10) + (random.randint(0,10)/100)
        city = citipy.nearest_city(lat, lon)
        cityname = city.city_name
        if (not(cityname in cities)):
            cities.append(cityname)
            i = i + 1



generate_cities(samplesize)
```

## Perform API Calls


```python
weather_data = []
counter = 1
settings = {"units": "metric", "appid": api_key}
print("Beginning Data Retrieval\n------------------------")
url = "http://api.openweathermap.org/data/2.5/weather?"
units = "metric"
for city in cities:    
    print(f"Processing city {counter} of {samplesize} | {city}")
    cityjoined = "_".join(city.split())
    counter = counter + 1
    try:
        weather_data.append(ow.get_current(city, **settings))
        query_url = f"{url}appid={api_key}&q={cityjoined}&units={units}"
        print(query_url)
    except:
        print(f"Data for {city} not found.")
        
print("------------------------\nData Retrieval Complete\n------------------------")
```

    Beginning Data Retrieval
    ------------------------
    Processing city 1 of 700 | punta arenas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=punta_arenas&units=metric
    Processing city 2 of 700 | rikitea
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rikitea&units=metric
    Processing city 3 of 700 | arraial do cabo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=arraial_do_cabo&units=metric
    Processing city 4 of 700 | georgetown
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=georgetown&units=metric
    Processing city 5 of 700 | puerto ayora
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=puerto_ayora&units=metric
    Processing city 6 of 700 | hermanus
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hermanus&units=metric
    Processing city 7 of 700 | mataura
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mataura&units=metric
    Processing city 8 of 700 | lebu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lebu&units=metric
    Processing city 9 of 700 | avarua
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=avarua&units=metric
    Processing city 10 of 700 | chuy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=chuy&units=metric
    Processing city 11 of 700 | coquimbo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=coquimbo&units=metric
    Processing city 12 of 700 | ushuaia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ushuaia&units=metric
    Processing city 13 of 700 | caravelas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=caravelas&units=metric
    Processing city 14 of 700 | avera
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=avera&units=metric
    Processing city 15 of 700 | mar del plata
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mar_del_plata&units=metric
    Processing city 16 of 700 | atuona
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=atuona&units=metric
    Processing city 17 of 700 | vaini
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vaini&units=metric
    Processing city 18 of 700 | taguatinga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=taguatinga&units=metric
    Processing city 19 of 700 | muana
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=muana&units=metric
    Processing city 20 of 700 | aripuana
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=aripuana&units=metric
    Processing city 21 of 700 | san cristobal
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=san_cristobal&units=metric
    Processing city 22 of 700 | jamestown
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=jamestown&units=metric
    Processing city 23 of 700 | alofi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=alofi&units=metric
    Processing city 24 of 700 | cape town
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cape_town&units=metric
    Processing city 25 of 700 | saldanha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saldanha&units=metric
    Processing city 26 of 700 | castro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=castro&units=metric
    Processing city 27 of 700 | axim
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=axim&units=metric
    Processing city 28 of 700 | luderitz
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=luderitz&units=metric
    Processing city 29 of 700 | taltal
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=taltal&units=metric
    Processing city 30 of 700 | marcona
    Data for marcona not found.
    Processing city 31 of 700 | rio grande
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rio_grande&units=metric
    Processing city 32 of 700 | pisco
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pisco&units=metric
    Processing city 33 of 700 | timbo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=timbo&units=metric
    Processing city 34 of 700 | cidreira
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cidreira&units=metric
    Processing city 35 of 700 | belmonte
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=belmonte&units=metric
    Processing city 36 of 700 | imbituba
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=imbituba&units=metric
    Processing city 37 of 700 | novo aripuana
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=novo_aripuana&units=metric
    Processing city 38 of 700 | chicama
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=chicama&units=metric
    Processing city 39 of 700 | tabou
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tabou&units=metric
    Processing city 40 of 700 | touros
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=touros&units=metric
    Processing city 41 of 700 | sao joao da barra
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sao_joao_da_barra&units=metric
    Processing city 42 of 700 | sao jose da coroa grande
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sao_jose_da_coroa_grande&units=metric
    Processing city 43 of 700 | itaueira
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=itaueira&units=metric
    Processing city 44 of 700 | valparaiso
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=valparaiso&units=metric
    Processing city 45 of 700 | vila velha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vila_velha&units=metric
    Processing city 46 of 700 | hualmay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hualmay&units=metric
    Processing city 47 of 700 | vaitupu
    Data for vaitupu not found.
    Processing city 48 of 700 | iquique
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=iquique&units=metric
    Processing city 49 of 700 | rocha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rocha&units=metric
    Processing city 50 of 700 | faanui
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=faanui&units=metric
    Processing city 51 of 700 | laguna
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=laguna&units=metric
    Processing city 52 of 700 | samusu
    Data for samusu not found.
    Processing city 53 of 700 | coihaique
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=coihaique&units=metric
    Processing city 54 of 700 | challapata
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=challapata&units=metric
    Processing city 55 of 700 | nortelandia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nortelandia&units=metric
    Processing city 56 of 700 | alta floresta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=alta_floresta&units=metric
    Processing city 57 of 700 | piracanjuba
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=piracanjuba&units=metric
    Processing city 58 of 700 | iaciara
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=iaciara&units=metric
    Processing city 59 of 700 | la brea
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=la_brea&units=metric
    Processing city 60 of 700 | ilheus
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ilheus&units=metric
    Processing city 61 of 700 | mollendo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mollendo&units=metric
    Processing city 62 of 700 | ilhabela
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ilhabela&units=metric
    Processing city 63 of 700 | villarrica
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=villarrica&units=metric
    Processing city 64 of 700 | san carlos de bariloche
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=san_carlos_de_bariloche&units=metric
    Processing city 65 of 700 | la ligua
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=la_ligua&units=metric
    Processing city 66 of 700 | formoso do araguaia
    Data for formoso do araguaia not found.
    Processing city 67 of 700 | ancud
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ancud&units=metric
    Processing city 68 of 700 | arica
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=arica&units=metric
    Processing city 69 of 700 | santa rosa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=santa_rosa&units=metric
    Processing city 70 of 700 | santa cruz cabralia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=santa_cruz_cabralia&units=metric
    Processing city 71 of 700 | tautira
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tautira&units=metric
    Processing city 72 of 700 | altamira
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=altamira&units=metric
    Processing city 73 of 700 | sataua
    Data for sataua not found.
    Processing city 74 of 700 | neuquen
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=neuquen&units=metric
    Processing city 75 of 700 | necochea
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=necochea&units=metric
    Processing city 76 of 700 | ituporanga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ituporanga&units=metric
    Processing city 77 of 700 | aragarcas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=aragarcas&units=metric
    Processing city 78 of 700 | sao gabriel da cachoeira
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sao_gabriel_da_cachoeira&units=metric
    Processing city 79 of 700 | guaraniacu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=guaraniacu&units=metric
    Processing city 80 of 700 | copiapo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=copiapo&units=metric
    Processing city 81 of 700 | santo amaro da imperatriz
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=santo_amaro_da_imperatriz&units=metric
    Processing city 82 of 700 | itacarambi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=itacarambi&units=metric
    Processing city 83 of 700 | san pedro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=san_pedro&units=metric
    Processing city 84 of 700 | santa luzia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=santa_luzia&units=metric
    Processing city 85 of 700 | satitoa
    Data for satitoa not found.
    Processing city 86 of 700 | monte santo de minas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=monte_santo_de_minas&units=metric
    Processing city 87 of 700 | maceio
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=maceio&units=metric
    Processing city 88 of 700 | presidencia roque saenz pena
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=presidencia_roque_saenz_pena&units=metric
    Processing city 89 of 700 | comodoro rivadavia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=comodoro_rivadavia&units=metric
    Processing city 90 of 700 | vicuna
    Data for vicuna not found.
    Processing city 91 of 700 | armacao dos buzios
    Data for armacao dos buzios not found.
    Processing city 92 of 700 | requena
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=requena&units=metric
    Processing city 93 of 700 | sechura
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sechura&units=metric
    Processing city 94 of 700 | tucurui
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tucurui&units=metric
    Processing city 95 of 700 | rawson
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rawson&units=metric
    Processing city 96 of 700 | saleaula
    Data for saleaula not found.
    Processing city 97 of 700 | guarapari
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=guarapari&units=metric
    Processing city 98 of 700 | itapuranga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=itapuranga&units=metric
    Processing city 99 of 700 | la rioja
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=la_rioja&units=metric
    Processing city 100 of 700 | camana
    Data for camana not found.
    Processing city 101 of 700 | maragogi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=maragogi&units=metric
    Processing city 102 of 700 | puerto madryn
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=puerto_madryn&units=metric
    Processing city 103 of 700 | rivadavia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rivadavia&units=metric
    Processing city 104 of 700 | coahuayana
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=coahuayana&units=metric
    Processing city 105 of 700 | talara
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=talara&units=metric
    Processing city 106 of 700 | rio gallegos
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rio_gallegos&units=metric
    Processing city 107 of 700 | viedma
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=viedma&units=metric
    Processing city 108 of 700 | tocopilla
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tocopilla&units=metric
    Processing city 109 of 700 | santa vitoria
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=santa_vitoria&units=metric
    Processing city 110 of 700 | el alto
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=el_alto&units=metric
    Processing city 111 of 700 | salinas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=salinas&units=metric
    Processing city 112 of 700 | villa maria
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=villa_maria&units=metric
    Processing city 113 of 700 | takoradi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=takoradi&units=metric
    Processing city 114 of 700 | camaqua
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=camaqua&units=metric
    Processing city 115 of 700 | ilo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ilo&units=metric
    Processing city 116 of 700 | sao felix do xingu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sao_felix_do_xingu&units=metric
    Processing city 117 of 700 | filadelfia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=filadelfia&units=metric
    Processing city 118 of 700 | mapiri
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mapiri&units=metric
    Processing city 119 of 700 | bom jesus
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bom_jesus&units=metric
    Processing city 120 of 700 | amarante do maranhao
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=amarante_do_maranhao&units=metric
    Processing city 121 of 700 | salta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=salta&units=metric
    Processing city 122 of 700 | ipora
    Data for ipora not found.
    Processing city 123 of 700 | gilbues
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gilbues&units=metric
    Processing city 124 of 700 | mineiros
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mineiros&units=metric
    Processing city 125 of 700 | conde
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=conde&units=metric
    Processing city 126 of 700 | casma
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=casma&units=metric
    Processing city 127 of 700 | camargo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=camargo&units=metric
    Processing city 128 of 700 | sao joao batista
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sao_joao_batista&units=metric
    Processing city 129 of 700 | huarmey
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=huarmey&units=metric
    Processing city 130 of 700 | tefe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tefe&units=metric
    Processing city 131 of 700 | pozo colorado
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pozo_colorado&units=metric
    Processing city 132 of 700 | alenquer
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=alenquer&units=metric
    Processing city 133 of 700 | urubicha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=urubicha&units=metric
    Processing city 134 of 700 | pomabamba
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pomabamba&units=metric
    Processing city 135 of 700 | bambamarca
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bambamarca&units=metric
    Processing city 136 of 700 | barbalha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=barbalha&units=metric
    Processing city 137 of 700 | bahia blanca
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bahia_blanca&units=metric
    Processing city 138 of 700 | tucuman
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tucuman&units=metric
    Processing city 139 of 700 | macau
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=macau&units=metric
    Processing city 140 of 700 | iquitos
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=iquitos&units=metric
    Processing city 141 of 700 | angra dos reis
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=angra_dos_reis&units=metric
    Processing city 142 of 700 | itaituba
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=itaituba&units=metric
    Processing city 143 of 700 | diego de almagro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=diego_de_almagro&units=metric
    Processing city 144 of 700 | santiago del estero
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=santiago_del_estero&units=metric
    Processing city 145 of 700 | boca do acre
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=boca_do_acre&units=metric
    Processing city 146 of 700 | talcahuano
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=talcahuano&units=metric
    Processing city 147 of 700 | pitimbu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pitimbu&units=metric
    Processing city 148 of 700 | miguel calmon
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=miguel_calmon&units=metric
    Processing city 149 of 700 | biguacu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=biguacu&units=metric
    Processing city 150 of 700 | tena
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tena&units=metric
    Processing city 151 of 700 | san patricio
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=san_patricio&units=metric
    Processing city 152 of 700 | panguipulli
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=panguipulli&units=metric
    Processing city 153 of 700 | pimentel
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pimentel&units=metric
    Processing city 154 of 700 | mendoza
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mendoza&units=metric
    Processing city 155 of 700 | pedro juan caballero
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pedro_juan_caballero&units=metric
    Processing city 156 of 700 | contamana
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=contamana&units=metric
    Processing city 157 of 700 | presidente epitacio
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=presidente_epitacio&units=metric
    Processing city 158 of 700 | ladario
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ladario&units=metric
    Processing city 159 of 700 | pontes e lacerda
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pontes_e_lacerda&units=metric
    Processing city 160 of 700 | antofagasta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=antofagasta&units=metric
    Processing city 161 of 700 | niquelandia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=niquelandia&units=metric
    Processing city 162 of 700 | presidente medici
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=presidente_medici&units=metric
    Processing city 163 of 700 | chilca
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=chilca&units=metric
    Processing city 164 of 700 | reserva
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=reserva&units=metric
    Processing city 165 of 700 | alterosa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=alterosa&units=metric
    Processing city 166 of 700 | trinidad
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=trinidad&units=metric
    Processing city 167 of 700 | campoverde
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=campoverde&units=metric
    Processing city 168 of 700 | quirinopolis
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=quirinopolis&units=metric
    Processing city 169 of 700 | tamandare
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tamandare&units=metric
    Processing city 170 of 700 | lapa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lapa&units=metric
    Processing city 171 of 700 | cachoeira do sul
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cachoeira_do_sul&units=metric
    Processing city 172 of 700 | reconquista
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=reconquista&units=metric
    Processing city 173 of 700 | anori
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=anori&units=metric
    Processing city 174 of 700 | halalo
    Data for halalo not found.
    Processing city 175 of 700 | lufilufi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lufilufi&units=metric
    Processing city 176 of 700 | norman wells
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=norman_wells&units=metric
    Processing city 177 of 700 | illoqqortoormiut
    Data for illoqqortoormiut not found.
    Processing city 178 of 700 | qaanaaq
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=qaanaaq&units=metric
    Processing city 179 of 700 | yellowknife
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=yellowknife&units=metric
    Processing city 180 of 700 | fortuna
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=fortuna&units=metric
    Processing city 181 of 700 | granada
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=granada&units=metric
    Processing city 182 of 700 | saint george
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saint_george&units=metric
    Processing city 183 of 700 | atar
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=atar&units=metric
    Processing city 184 of 700 | susanville
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=susanville&units=metric
    Processing city 185 of 700 | dingle
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dingle&units=metric
    Processing city 186 of 700 | puerto el triunfo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=puerto_el_triunfo&units=metric
    Processing city 187 of 700 | haines junction
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=haines_junction&units=metric
    Processing city 188 of 700 | cabo san lucas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cabo_san_lucas&units=metric
    Processing city 189 of 700 | north bend
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=north_bend&units=metric
    Processing city 190 of 700 | aklavik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=aklavik&units=metric
    Processing city 191 of 700 | chino valley
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=chino_valley&units=metric
    Processing city 192 of 700 | porto novo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=porto_novo&units=metric
    Processing city 193 of 700 | bubaque
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bubaque&units=metric
    Processing city 194 of 700 | olafsvik
    Data for olafsvik not found.
    Processing city 195 of 700 | barrow
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=barrow&units=metric
    Processing city 196 of 700 | keflavik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=keflavik&units=metric
    Processing city 197 of 700 | sisimiut
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sisimiut&units=metric
    Processing city 198 of 700 | chapais
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=chapais&units=metric
    Processing city 199 of 700 | kapaa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kapaa&units=metric
    Processing city 200 of 700 | thompson
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=thompson&units=metric
    Processing city 201 of 700 | vila franca do campo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vila_franca_do_campo&units=metric
    Processing city 202 of 700 | torbay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=torbay&units=metric
    Processing city 203 of 700 | lompoc
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lompoc&units=metric
    Processing city 204 of 700 | ribeira grande
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ribeira_grande&units=metric
    Processing city 205 of 700 | buchanan
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=buchanan&units=metric
    Processing city 206 of 700 | bow island
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bow_island&units=metric
    Processing city 207 of 700 | mumford
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mumford&units=metric
    Processing city 208 of 700 | koforidua
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=koforidua&units=metric
    Processing city 209 of 700 | puerto cabezas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=puerto_cabezas&units=metric
    Processing city 210 of 700 | lewisporte
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lewisporte&units=metric
    Processing city 211 of 700 | mana
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mana&units=metric
    Processing city 212 of 700 | sorvag
    Data for sorvag not found.
    Processing city 213 of 700 | back mountain
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=back_mountain&units=metric
    Processing city 214 of 700 | la trinitaria
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=la_trinitaria&units=metric
    Processing city 215 of 700 | payson
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=payson&units=metric
    Processing city 216 of 700 | attawapiskat
    Data for attawapiskat not found.
    Processing city 217 of 700 | upernavik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=upernavik&units=metric
    Processing city 218 of 700 | tuktoyaktuk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tuktoyaktuk&units=metric
    Processing city 219 of 700 | saint anthony
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saint_anthony&units=metric
    Processing city 220 of 700 | constitucion
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=constitucion&units=metric
    Processing city 221 of 700 | vestmannaeyjar
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vestmannaeyjar&units=metric
    Processing city 222 of 700 | provideniya
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=provideniya&units=metric
    Processing city 223 of 700 | hilo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hilo&units=metric
    Processing city 224 of 700 | ketchikan
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ketchikan&units=metric
    Processing city 225 of 700 | hamilton
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hamilton&units=metric
    Processing city 226 of 700 | bay roberts
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bay_roberts&units=metric
    Processing city 227 of 700 | iqaluit
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=iqaluit&units=metric
    Processing city 228 of 700 | nome
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nome&units=metric
    Processing city 229 of 700 | ilulissat
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ilulissat&units=metric
    Processing city 230 of 700 | socorro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=socorro&units=metric
    Processing city 231 of 700 | constanza
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=constanza&units=metric
    Processing city 232 of 700 | lander
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lander&units=metric
    Processing city 233 of 700 | saint-augustin
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saint-augustin&units=metric
    Processing city 234 of 700 | bethel
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bethel&units=metric
    Processing city 235 of 700 | amapa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=amapa&units=metric
    Processing city 236 of 700 | bonthe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bonthe&units=metric
    Processing city 237 of 700 | stony mountain
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=stony_mountain&units=metric
    Processing city 238 of 700 | kodiak
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kodiak&units=metric
    Processing city 239 of 700 | san lorenzo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=san_lorenzo&units=metric
    Processing city 240 of 700 | sao filipe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sao_filipe&units=metric
    Processing city 241 of 700 | coro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=coro&units=metric
    Processing city 242 of 700 | louisbourg
    Data for louisbourg not found.
    Processing city 243 of 700 | narsaq
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=narsaq&units=metric
    Processing city 244 of 700 | la ronge
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=la_ronge&units=metric
    Processing city 245 of 700 | pangnirtung
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pangnirtung&units=metric
    Processing city 246 of 700 | codrington
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=codrington&units=metric
    Processing city 247 of 700 | corinto
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=corinto&units=metric
    Processing city 248 of 700 | tasiilaq
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tasiilaq&units=metric
    Processing city 249 of 700 | thunder bay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=thunder_bay&units=metric
    Processing city 250 of 700 | sitka
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sitka&units=metric
    Processing city 251 of 700 | great falls
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=great_falls&units=metric
    Processing city 252 of 700 | prescott
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=prescott&units=metric
    Processing city 253 of 700 | manzanillo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=manzanillo&units=metric
    Processing city 254 of 700 | tessalit
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tessalit&units=metric
    Processing city 255 of 700 | guerrero negro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=guerrero_negro&units=metric
    Processing city 256 of 700 | norfolk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=norfolk&units=metric
    Processing city 257 of 700 | san jose
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=san_jose&units=metric
    Processing city 258 of 700 | faranah
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=faranah&units=metric
    Processing city 259 of 700 | mys shmidta
    Data for mys shmidta not found.
    Processing city 260 of 700 | boa vista
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=boa_vista&units=metric
    Processing city 261 of 700 | puerto escondido
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=puerto_escondido&units=metric
    Processing city 262 of 700 | grants
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=grants&units=metric
    Processing city 263 of 700 | nouadhibou
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nouadhibou&units=metric
    Processing city 264 of 700 | barentsburg
    Data for barentsburg not found.
    Processing city 265 of 700 | klaksvik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=klaksvik&units=metric
    Processing city 266 of 700 | clyde river
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=clyde_river&units=metric
    Processing city 267 of 700 | husavik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=husavik&units=metric
    Processing city 268 of 700 | wembley
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=wembley&units=metric
    Processing city 269 of 700 | nicoya
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nicoya&units=metric
    Processing city 270 of 700 | ponta do sol
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ponta_do_sol&units=metric
    Processing city 271 of 700 | prince albert
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=prince_albert&units=metric
    Processing city 272 of 700 | bermeo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bermeo&units=metric
    Processing city 273 of 700 | kahului
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kahului&units=metric
    Processing city 274 of 700 | hailey
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hailey&units=metric
    Processing city 275 of 700 | bridgwater
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bridgwater&units=metric
    Processing city 276 of 700 | invermere
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=invermere&units=metric
    Processing city 277 of 700 | acapulco
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=acapulco&units=metric
    Processing city 278 of 700 | gustavo diaz ordaz
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gustavo_diaz_ordaz&units=metric
    Processing city 279 of 700 | gallup
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gallup&units=metric
    Processing city 280 of 700 | ojinaga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ojinaga&units=metric
    Processing city 281 of 700 | williams lake
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=williams_lake&units=metric
    Processing city 282 of 700 | stromness
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=stromness&units=metric
    Processing city 283 of 700 | bakel
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bakel&units=metric
    Processing city 284 of 700 | inuvik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=inuvik&units=metric
    Processing city 285 of 700 | college
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=college&units=metric
    Processing city 286 of 700 | choix
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=choix&units=metric
    Processing city 287 of 700 | nantucket
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nantucket&units=metric
    Processing city 288 of 700 | angra
    Data for angra not found.
    Processing city 289 of 700 | bathsheba
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bathsheba&units=metric
    Processing city 290 of 700 | wahran
    Data for wahran not found.
    Processing city 291 of 700 | santa fe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=santa_fe&units=metric
    Processing city 292 of 700 | mayo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mayo&units=metric
    Processing city 293 of 700 | san quintin
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=san_quintin&units=metric
    Processing city 294 of 700 | novita
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=novita&units=metric
    Processing city 295 of 700 | lagoa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lagoa&units=metric
    Processing city 296 of 700 | acarau
    Data for acarau not found.
    Processing city 297 of 700 | wa
    Data for wa not found.
    Processing city 298 of 700 | la asuncion
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=la_asuncion&units=metric
    Processing city 299 of 700 | morgan city
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=morgan_city&units=metric
    Processing city 300 of 700 | nanortalik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nanortalik&units=metric
    Processing city 301 of 700 | antiguo morelos
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=antiguo_morelos&units=metric
    Processing city 302 of 700 | charlestown
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=charlestown&units=metric
    Processing city 303 of 700 | portobelo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=portobelo&units=metric
    Processing city 304 of 700 | fairmont
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=fairmont&units=metric
    Processing city 305 of 700 | rabo de peixe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rabo_de_peixe&units=metric
    Processing city 306 of 700 | marsh harbour
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=marsh_harbour&units=metric
    Processing city 307 of 700 | grindavik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=grindavik&units=metric
    Processing city 308 of 700 | sept-iles
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sept-iles&units=metric
    Processing city 309 of 700 | saint-prosper
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saint-prosper&units=metric
    Processing city 310 of 700 | paris
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=paris&units=metric
    Processing city 311 of 700 | guia de isora
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=guia_de_isora&units=metric
    Processing city 312 of 700 | eureka
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=eureka&units=metric
    Processing city 313 of 700 | lamar
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lamar&units=metric
    Processing city 314 of 700 | hackettstown
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hackettstown&units=metric
    Processing city 315 of 700 | avila
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=avila&units=metric
    Processing city 316 of 700 | praia da vitoria
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=praia_da_vitoria&units=metric
    Processing city 317 of 700 | morristown
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=morristown&units=metric
    Processing city 318 of 700 | escarcega
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=escarcega&units=metric
    Processing city 319 of 700 | pochutla
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pochutla&units=metric
    Processing city 320 of 700 | arona
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=arona&units=metric
    Processing city 321 of 700 | santa eulalia del rio
    Data for santa eulalia del rio not found.
    Processing city 322 of 700 | acajutla
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=acajutla&units=metric
    Processing city 323 of 700 | palmer
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=palmer&units=metric
    Processing city 324 of 700 | nuuk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nuuk&units=metric
    Processing city 325 of 700 | hereford
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hereford&units=metric
    Processing city 326 of 700 | selfoss
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=selfoss&units=metric
    Processing city 327 of 700 | cayenne
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cayenne&units=metric
    Processing city 328 of 700 | virginia beach
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=virginia_beach&units=metric
    Processing city 329 of 700 | los llanos de aridane
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=los_llanos_de_aridane&units=metric
    Processing city 330 of 700 | adrar
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=adrar&units=metric
    Processing city 331 of 700 | paamiut
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=paamiut&units=metric
    Processing city 332 of 700 | paraiso
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=paraiso&units=metric
    Processing city 333 of 700 | peniche
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=peniche&units=metric
    Processing city 334 of 700 | morant bay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=morant_bay&units=metric
    Processing city 335 of 700 | mount holly
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mount_holly&units=metric
    Processing city 336 of 700 | pombas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pombas&units=metric
    Processing city 337 of 700 | port hardy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port_hardy&units=metric
    Processing city 338 of 700 | dillon
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dillon&units=metric
    Processing city 339 of 700 | astoria
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=astoria&units=metric
    Processing city 340 of 700 | green river
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=green_river&units=metric
    Processing city 341 of 700 | brigantine
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=brigantine&units=metric
    Processing city 342 of 700 | fort nelson
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=fort_nelson&units=metric
    Processing city 343 of 700 | marrakesh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=marrakesh&units=metric
    Processing city 344 of 700 | moose factory
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=moose_factory&units=metric
    Processing city 345 of 700 | iralaya
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=iralaya&units=metric
    Processing city 346 of 700 | restrepo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=restrepo&units=metric
    Processing city 347 of 700 | havre-saint-pierre
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=havre-saint-pierre&units=metric
    Processing city 348 of 700 | champerico
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=champerico&units=metric
    Processing city 349 of 700 | brownsville
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=brownsville&units=metric
    Processing city 350 of 700 | lazaro cardenas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lazaro_cardenas&units=metric
    Processing city 351 of 700 | voh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=voh&units=metric
    Processing city 352 of 700 | busselton
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=busselton&units=metric
    Processing city 353 of 700 | bluff
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bluff&units=metric
    Processing city 354 of 700 | meulaboh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=meulaboh&units=metric
    Processing city 355 of 700 | albany
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=albany&units=metric
    Processing city 356 of 700 | port elizabeth
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port_elizabeth&units=metric
    Processing city 357 of 700 | souillac
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=souillac&units=metric
    Processing city 358 of 700 | sri aman
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sri_aman&units=metric
    Processing city 359 of 700 | henties bay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=henties_bay&units=metric
    Processing city 360 of 700 | asau
    Data for asau not found.
    Processing city 361 of 700 | saint-philippe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saint-philippe&units=metric
    Processing city 362 of 700 | hithadhoo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hithadhoo&units=metric
    Processing city 363 of 700 | taolanaro
    Data for taolanaro not found.
    Processing city 364 of 700 | port keats
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port_keats&units=metric
    Processing city 365 of 700 | east london
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=east_london&units=metric
    Processing city 366 of 700 | yulara
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=yulara&units=metric
    Processing city 367 of 700 | new norfolk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=new_norfolk&units=metric
    Processing city 368 of 700 | sampit
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sampit&units=metric
    Processing city 369 of 700 | walvis bay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=walvis_bay&units=metric
    Processing city 370 of 700 | kilindoni
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kilindoni&units=metric
    Processing city 371 of 700 | hobart
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hobart&units=metric
    Processing city 372 of 700 | labuhan
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=labuhan&units=metric
    Processing city 373 of 700 | bredasdorp
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bredasdorp&units=metric
    Processing city 374 of 700 | boende
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=boende&units=metric
    Processing city 375 of 700 | boyolangu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=boyolangu&units=metric
    Processing city 376 of 700 | mahebourg
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mahebourg&units=metric
    Processing city 377 of 700 | port-gentil
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port-gentil&units=metric
    Processing city 378 of 700 | port alfred
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port_alfred&units=metric
    Processing city 379 of 700 | beira
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=beira&units=metric
    Processing city 380 of 700 | bambous virieux
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bambous_virieux&units=metric
    Processing city 381 of 700 | carnarvon
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=carnarvon&units=metric
    Processing city 382 of 700 | ruatoria
    Data for ruatoria not found.
    Processing city 383 of 700 | broken hill
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=broken_hill&units=metric
    Processing city 384 of 700 | kaitangata
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kaitangata&units=metric
    Processing city 385 of 700 | tsihombe
    Data for tsihombe not found.
    Processing city 386 of 700 | okahandja
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=okahandja&units=metric
    Processing city 387 of 700 | hastings
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hastings&units=metric
    Processing city 388 of 700 | opunake
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=opunake&units=metric
    Processing city 389 of 700 | senanga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=senanga&units=metric
    Processing city 390 of 700 | broome
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=broome&units=metric
    Processing city 391 of 700 | urambo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=urambo&units=metric
    Processing city 392 of 700 | bengkulu
    Data for bengkulu not found.
    Processing city 393 of 700 | charters towers
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=charters_towers&units=metric
    Processing city 394 of 700 | richards bay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=richards_bay&units=metric
    Processing city 395 of 700 | grand river south east
    Data for grand river south east not found.
    Processing city 396 of 700 | palabuhanratu
    Data for palabuhanratu not found.
    Processing city 397 of 700 | lusambo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lusambo&units=metric
    Processing city 398 of 700 | antalaha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=antalaha&units=metric
    Processing city 399 of 700 | poum
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=poum&units=metric
    Processing city 400 of 700 | sambava
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sambava&units=metric
    Processing city 401 of 700 | batemans bay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=batemans_bay&units=metric
    Processing city 402 of 700 | kirakira
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kirakira&units=metric
    Processing city 403 of 700 | khudumelapye
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=khudumelapye&units=metric
    Processing city 404 of 700 | luwuk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=luwuk&units=metric
    Processing city 405 of 700 | esperance
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=esperance&units=metric
    Processing city 406 of 700 | poso
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=poso&units=metric
    Processing city 407 of 700 | banjar
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=banjar&units=metric
    Processing city 408 of 700 | buala
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=buala&units=metric
    Processing city 409 of 700 | vohibinany
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vohibinany&units=metric
    Processing city 410 of 700 | geraldton
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=geraldton&units=metric
    Processing city 411 of 700 | bandrele
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bandrele&units=metric
    Processing city 412 of 700 | dunedin
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dunedin&units=metric
    Processing city 413 of 700 | calvinia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=calvinia&units=metric
    Processing city 414 of 700 | maua
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=maua&units=metric
    Processing city 415 of 700 | le port
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=le_port&units=metric
    Processing city 416 of 700 | cap malheureux
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cap_malheureux&units=metric
    Processing city 417 of 700 | kruisfontein
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kruisfontein&units=metric
    Processing city 418 of 700 | tual
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tual&units=metric
    Processing city 419 of 700 | mangai
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mangai&units=metric
    Processing city 420 of 700 | inhambane
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=inhambane&units=metric
    Processing city 421 of 700 | mount gambier
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mount_gambier&units=metric
    Processing city 422 of 700 | ambon
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ambon&units=metric
    Processing city 423 of 700 | tabiauea
    Data for tabiauea not found.
    Processing city 424 of 700 | praya
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=praya&units=metric
    Processing city 425 of 700 | port lincoln
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port_lincoln&units=metric
    Processing city 426 of 700 | lolua
    Data for lolua not found.
    Processing city 427 of 700 | cairns
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cairns&units=metric
    Processing city 428 of 700 | margate
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=margate&units=metric
    Processing city 429 of 700 | tuatapere
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tuatapere&units=metric
    Processing city 430 of 700 | isangel
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=isangel&units=metric
    Processing city 431 of 700 | taree
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=taree&units=metric
    Processing city 432 of 700 | gobabis
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gobabis&units=metric
    Processing city 433 of 700 | namatanai
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=namatanai&units=metric
    Processing city 434 of 700 | perth
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=perth&units=metric
    Processing city 435 of 700 | victoria
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=victoria&units=metric
    Processing city 436 of 700 | nelson bay
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nelson_bay&units=metric
    Processing city 437 of 700 | morondava
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=morondava&units=metric
    Processing city 438 of 700 | roebourne
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=roebourne&units=metric
    Processing city 439 of 700 | waipawa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=waipawa&units=metric
    Processing city 440 of 700 | noumea
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=noumea&units=metric
    Processing city 441 of 700 | hokitika
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hokitika&units=metric
    Processing city 442 of 700 | launceston
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=launceston&units=metric
    Processing city 443 of 700 | oranjemund
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=oranjemund&units=metric
    Processing city 444 of 700 | auki
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=auki&units=metric
    Processing city 445 of 700 | namibe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=namibe&units=metric
    Processing city 446 of 700 | zastron
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=zastron&units=metric
    Processing city 447 of 700 | vila
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vila&units=metric
    Processing city 448 of 700 | umzimvubu
    Data for umzimvubu not found.
    Processing city 449 of 700 | katherine
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=katherine&units=metric
    Processing city 450 of 700 | nampula
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nampula&units=metric
    Processing city 451 of 700 | westport
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=westport&units=metric
    Processing city 452 of 700 | nguiu
    Data for nguiu not found.
    Processing city 453 of 700 | letlhakeng
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=letlhakeng&units=metric
    Processing city 454 of 700 | sijunjung
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sijunjung&units=metric
    Processing city 455 of 700 | andilamena
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=andilamena&units=metric
    Processing city 456 of 700 | zambezi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=zambezi&units=metric
    Processing city 457 of 700 | gambiran
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gambiran&units=metric
    Processing city 458 of 700 | aitape
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=aitape&units=metric
    Processing city 459 of 700 | soyo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=soyo&units=metric
    Processing city 460 of 700 | northam
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=northam&units=metric
    Processing city 461 of 700 | bambanglipuro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bambanglipuro&units=metric
    Processing city 462 of 700 | ulladulla
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ulladulla&units=metric
    Processing city 463 of 700 | karratha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=karratha&units=metric
    Processing city 464 of 700 | opuwo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=opuwo&units=metric
    Processing city 465 of 700 | lupiro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lupiro&units=metric
    Processing city 466 of 700 | kindu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kindu&units=metric
    Processing city 467 of 700 | alice springs
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=alice_springs&units=metric
    Processing city 468 of 700 | manica
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=manica&units=metric
    Processing city 469 of 700 | gladstone
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gladstone&units=metric
    Processing city 470 of 700 | utiroa
    Data for utiroa not found.
    Processing city 471 of 700 | sibolga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sibolga&units=metric
    Processing city 472 of 700 | mikumi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mikumi&units=metric
    Processing city 473 of 700 | manggar
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=manggar&units=metric
    Processing city 474 of 700 | quthing
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=quthing&units=metric
    Processing city 475 of 700 | beloha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=beloha&units=metric
    Processing city 476 of 700 | bowen
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bowen&units=metric
    Processing city 477 of 700 | kununurra
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kununurra&units=metric
    Processing city 478 of 700 | townsville
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=townsville&units=metric
    Processing city 479 of 700 | mwense
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mwense&units=metric
    Processing city 480 of 700 | atambua
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=atambua&units=metric
    Processing city 481 of 700 | lodja
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lodja&units=metric
    Processing city 482 of 700 | madang
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=madang&units=metric
    Processing city 483 of 700 | lata
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lata&units=metric
    Processing city 484 of 700 | mareeba
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mareeba&units=metric
    Processing city 485 of 700 | flinders
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=flinders&units=metric
    Processing city 486 of 700 | mount isa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mount_isa&units=metric
    Processing city 487 of 700 | amahai
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=amahai&units=metric
    Processing city 488 of 700 | matara
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=matara&units=metric
    Processing city 489 of 700 | stawell
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=stawell&units=metric
    Processing city 490 of 700 | christchurch
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=christchurch&units=metric
    Processing city 491 of 700 | nhulunbuy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nhulunbuy&units=metric
    Processing city 492 of 700 | ambunti
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ambunti&units=metric
    Processing city 493 of 700 | bulungu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bulungu&units=metric
    Processing city 494 of 700 | grand gaube
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=grand_gaube&units=metric
    Processing city 495 of 700 | kieta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kieta&units=metric
    Processing city 496 of 700 | manokwari
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=manokwari&units=metric
    Processing city 497 of 700 | merauke
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=merauke&units=metric
    Processing city 498 of 700 | dargaville
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dargaville&units=metric
    Processing city 499 of 700 | limulunga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=limulunga&units=metric
    Processing city 500 of 700 | mayumba
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mayumba&units=metric
    Processing city 501 of 700 | atherton
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=atherton&units=metric
    Processing city 502 of 700 | kaeo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kaeo&units=metric
    Processing city 503 of 700 | ambulu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ambulu&units=metric
    Processing city 504 of 700 | kuito
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kuito&units=metric
    Processing city 505 of 700 | alyangula
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=alyangula&units=metric
    Processing city 506 of 700 | padang
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=padang&units=metric
    Processing city 507 of 700 | lae
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lae&units=metric
    Processing city 508 of 700 | portland
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=portland&units=metric
    Processing city 509 of 700 | honiara
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=honiara&units=metric
    Processing city 510 of 700 | namwala
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=namwala&units=metric
    Processing city 511 of 700 | dzaoudzi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dzaoudzi&units=metric
    Processing city 512 of 700 | maningrida
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=maningrida&units=metric
    Processing city 513 of 700 | vangaindrano
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vangaindrano&units=metric
    Processing city 514 of 700 | saint-louis
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saint-louis&units=metric
    Processing city 515 of 700 | vao
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vao&units=metric
    Processing city 516 of 700 | viligili
    Data for viligili not found.
    Processing city 517 of 700 | kijang
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kijang&units=metric
    Processing city 518 of 700 | port victoria
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port_victoria&units=metric
    Processing city 519 of 700 | camabatela
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=camabatela&units=metric
    Processing city 520 of 700 | waingapu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=waingapu&units=metric
    Processing city 521 of 700 | kasongo-lunda
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kasongo-lunda&units=metric
    Processing city 522 of 700 | umtata
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=umtata&units=metric
    Processing city 523 of 700 | hambantota
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hambantota&units=metric
    Processing city 524 of 700 | barawe
    Data for barawe not found.
    Processing city 525 of 700 | port augusta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=port_augusta&units=metric
    Processing city 526 of 700 | hall
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hall&units=metric
    Processing city 527 of 700 | anadyr
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=anadyr&units=metric
    Processing city 528 of 700 | kushima
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kushima&units=metric
    Processing city 529 of 700 | gat
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gat&units=metric
    Processing city 530 of 700 | arkhangelskoye
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=arkhangelskoye&units=metric
    Processing city 531 of 700 | severo-kurilsk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=severo-kurilsk&units=metric
    Processing city 532 of 700 | dezful
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dezful&units=metric
    Processing city 533 of 700 | den helder
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=den_helder&units=metric
    Processing city 534 of 700 | vinukonda
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vinukonda&units=metric
    Processing city 535 of 700 | tiksi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tiksi&units=metric
    Processing city 536 of 700 | rochegda
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rochegda&units=metric
    Processing city 537 of 700 | yirol
    Data for yirol not found.
    Processing city 538 of 700 | salalah
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=salalah&units=metric
    Processing city 539 of 700 | blagoyevo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=blagoyevo&units=metric
    Processing city 540 of 700 | amderma
    Data for amderma not found.
    Processing city 541 of 700 | ust-maya
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ust-maya&units=metric
    Processing city 542 of 700 | sarh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sarh&units=metric
    Processing city 543 of 700 | xining
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=xining&units=metric
    Processing city 544 of 700 | annau
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=annau&units=metric
    Processing city 545 of 700 | khvastovichi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=khvastovichi&units=metric
    Processing city 546 of 700 | riyadh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=riyadh&units=metric
    Processing city 547 of 700 | alekseyevsk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=alekseyevsk&units=metric
    Processing city 548 of 700 | komsomolskiy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=komsomolskiy&units=metric
    Processing city 549 of 700 | bardiyah
    Data for bardiyah not found.
    Processing city 550 of 700 | kedrovyy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kedrovyy&units=metric
    Processing city 551 of 700 | deputatskiy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=deputatskiy&units=metric
    Processing city 552 of 700 | sompeta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sompeta&units=metric
    Processing city 553 of 700 | kudahuvadhoo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kudahuvadhoo&units=metric
    Processing city 554 of 700 | sentyabrskiy
    Data for sentyabrskiy not found.
    Processing city 555 of 700 | saskylakh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=saskylakh&units=metric
    Processing city 556 of 700 | beringovskiy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=beringovskiy&units=metric
    Processing city 557 of 700 | pevek
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=pevek&units=metric
    Processing city 558 of 700 | hammerfest
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hammerfest&units=metric
    Processing city 559 of 700 | hirtshals
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hirtshals&units=metric
    Processing city 560 of 700 | diffa
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=diffa&units=metric
    Processing city 561 of 700 | hanyang
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hanyang&units=metric
    Processing city 562 of 700 | butaritari
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=butaritari&units=metric
    Processing city 563 of 700 | sartana
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sartana&units=metric
    Processing city 564 of 700 | clacton-on-sea
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=clacton-on-sea&units=metric
    Processing city 565 of 700 | nadapuram
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nadapuram&units=metric
    Processing city 566 of 700 | keta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=keta&units=metric
    Processing city 567 of 700 | takanabe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=takanabe&units=metric
    Processing city 568 of 700 | rungata
    Data for rungata not found.
    Processing city 569 of 700 | tubruq
    Data for tubruq not found.
    Processing city 570 of 700 | ostrovnoy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=ostrovnoy&units=metric
    Processing city 571 of 700 | darhan
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=darhan&units=metric
    Processing city 572 of 700 | belushya guba
    Data for belushya guba not found.
    Processing city 573 of 700 | urusha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=urusha&units=metric
    Processing city 574 of 700 | eyl
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=eyl&units=metric
    Processing city 575 of 700 | cherskiy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=cherskiy&units=metric
    Processing city 576 of 700 | enshi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=enshi&units=metric
    Processing city 577 of 700 | norwich
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=norwich&units=metric
    Processing city 578 of 700 | dikson
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dikson&units=metric
    Processing city 579 of 700 | zholymbet
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=zholymbet&units=metric
    Processing city 580 of 700 | bairiki
    Data for bairiki not found.
    Processing city 581 of 700 | kashi
    Data for kashi not found.
    Processing city 582 of 700 | hasaki
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hasaki&units=metric
    Processing city 583 of 700 | lorengau
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lorengau&units=metric
    Processing city 584 of 700 | tabas
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tabas&units=metric
    Processing city 585 of 700 | airai
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=airai&units=metric
    Processing city 586 of 700 | hami
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hami&units=metric
    Processing city 587 of 700 | kyaikkami
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kyaikkami&units=metric
    Processing city 588 of 700 | yar-sale
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=yar-sale&units=metric
    Processing city 589 of 700 | ondorhaan
    Data for ondorhaan not found.
    Processing city 590 of 700 | bratsk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bratsk&units=metric
    Processing city 591 of 700 | vanimo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vanimo&units=metric
    Processing city 592 of 700 | yatou
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=yatou&units=metric
    Processing city 593 of 700 | beihai
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=beihai&units=metric
    Processing city 594 of 700 | torbat-e jam
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=torbat-e_jam&units=metric
    Processing city 595 of 700 | chokurdakh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=chokurdakh&units=metric
    Processing city 596 of 700 | naze
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=naze&units=metric
    Processing city 597 of 700 | sistranda
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sistranda&units=metric
    Processing city 598 of 700 | verkhnevilyuysk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=verkhnevilyuysk&units=metric
    Processing city 599 of 700 | kutum
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kutum&units=metric
    Processing city 600 of 700 | teya
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=teya&units=metric
    Processing city 601 of 700 | talnakh
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=talnakh&units=metric
    Processing city 602 of 700 | srednekolymsk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=srednekolymsk&units=metric
    Processing city 603 of 700 | verkhoyansk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=verkhoyansk&units=metric
    Processing city 604 of 700 | mahadday weyne
    Data for mahadday weyne not found.
    Processing city 605 of 700 | marawi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=marawi&units=metric
    Processing city 606 of 700 | petropavlovsk-kamchatskiy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=petropavlovsk-kamchatskiy&units=metric
    Processing city 607 of 700 | nikolskoye
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nikolskoye&units=metric
    Processing city 608 of 700 | tommot
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tommot&units=metric
    Processing city 609 of 700 | bandarbeyla
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bandarbeyla&units=metric
    Processing city 610 of 700 | kathmandu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kathmandu&units=metric
    Processing city 611 of 700 | porbandar
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=porbandar&units=metric
    Processing city 612 of 700 | kargasok
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kargasok&units=metric
    Processing city 613 of 700 | shaoyang
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=shaoyang&units=metric
    Processing city 614 of 700 | khorinsk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=khorinsk&units=metric
    Processing city 615 of 700 | nanning
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nanning&units=metric
    Processing city 616 of 700 | phan thiet
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=phan_thiet&units=metric
    Processing city 617 of 700 | diu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=diu&units=metric
    Processing city 618 of 700 | nizhniy tsasuchey
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nizhniy_tsasuchey&units=metric
    Processing city 619 of 700 | faya
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=faya&units=metric
    Processing city 620 of 700 | botou
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=botou&units=metric
    Processing city 621 of 700 | wladyslawowo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=wladyslawowo&units=metric
    Processing city 622 of 700 | berlevag
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=berlevag&units=metric
    Processing city 623 of 700 | roald
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=roald&units=metric
    Processing city 624 of 700 | mergui
    Data for mergui not found.
    Processing city 625 of 700 | berbera
    Data for berbera not found.
    Processing city 626 of 700 | nemuro
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nemuro&units=metric
    Processing city 627 of 700 | abashiri
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=abashiri&units=metric
    Processing city 628 of 700 | mecca
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mecca&units=metric
    Processing city 629 of 700 | sonari
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sonari&units=metric
    Processing city 630 of 700 | buzmeyin
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=buzmeyin&units=metric
    Processing city 631 of 700 | leningradskiy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=leningradskiy&units=metric
    Processing city 632 of 700 | khatanga
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=khatanga&units=metric
    Processing city 633 of 700 | bafia
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bafia&units=metric
    Processing city 634 of 700 | buraydah
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=buraydah&units=metric
    Processing city 635 of 700 | bereda
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=bereda&units=metric
    Processing city 636 of 700 | katsuura
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=katsuura&units=metric
    Processing city 637 of 700 | nizhneyansk
    Data for nizhneyansk not found.
    Processing city 638 of 700 | zhezkazgan
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=zhezkazgan&units=metric
    Processing city 639 of 700 | andenes
    Data for andenes not found.
    Processing city 640 of 700 | dullewala
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dullewala&units=metric
    Processing city 641 of 700 | takestan
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=takestan&units=metric
    Processing city 642 of 700 | okhotsk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=okhotsk&units=metric
    Processing city 643 of 700 | suez
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=suez&units=metric
    Processing city 644 of 700 | sorgun
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sorgun&units=metric
    Processing city 645 of 700 | sakakah
    Data for sakakah not found.
    Processing city 646 of 700 | vardo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vardo&units=metric
    Processing city 647 of 700 | esil
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=esil&units=metric
    Processing city 648 of 700 | turtkul
    Data for turtkul not found.
    Processing city 649 of 700 | akdepe
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=akdepe&units=metric
    Processing city 650 of 700 | kousseri
    Data for kousseri not found.
    Processing city 651 of 700 | margherita
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=margherita&units=metric
    Processing city 652 of 700 | abu dhabi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=abu_dhabi&units=metric
    Processing city 653 of 700 | tura
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tura&units=metric
    Processing city 654 of 700 | buloh kasap
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=buloh_kasap&units=metric
    Processing city 655 of 700 | myaundzha
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=myaundzha&units=metric
    Processing city 656 of 700 | longyearbyen
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=longyearbyen&units=metric
    Processing city 657 of 700 | rawannawi
    Data for rawannawi not found.
    Processing city 658 of 700 | miri
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=miri&units=metric
    Processing city 659 of 700 | jalu
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=jalu&units=metric
    Processing city 660 of 700 | tokmak
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tokmak&units=metric
    Processing city 661 of 700 | malwan
    Data for malwan not found.
    Processing city 662 of 700 | zhaoqing
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=zhaoqing&units=metric
    Processing city 663 of 700 | quzhou
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=quzhou&units=metric
    Processing city 664 of 700 | kamenskoye
    Data for kamenskoye not found.
    Processing city 665 of 700 | meyungs
    Data for meyungs not found.
    Processing city 666 of 700 | horadiz
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=horadiz&units=metric
    Processing city 667 of 700 | dubrovnik
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=dubrovnik&units=metric
    Processing city 668 of 700 | linapacan
    Data for linapacan not found.
    Processing city 669 of 700 | simao
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=simao&units=metric
    Processing city 670 of 700 | mongo
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mongo&units=metric
    Processing city 671 of 700 | umm lajj
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=umm_lajj&units=metric
    Processing city 672 of 700 | sur
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sur&units=metric
    Processing city 673 of 700 | umea
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=umea&units=metric
    Processing city 674 of 700 | maloshuyka
    Data for maloshuyka not found.
    Processing city 675 of 700 | iranshahr
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=iranshahr&units=metric
    Processing city 676 of 700 | kant
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kant&units=metric
    Processing city 677 of 700 | gumdag
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=gumdag&units=metric
    Processing city 678 of 700 | nushki
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nushki&units=metric
    Processing city 679 of 700 | kavieng
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kavieng&units=metric
    Processing city 680 of 700 | tsimlyansk
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=tsimlyansk&units=metric
    Processing city 681 of 700 | vasai
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=vasai&units=metric
    Processing city 682 of 700 | shimoda
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=shimoda&units=metric
    Processing city 683 of 700 | sibut
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=sibut&units=metric
    Processing city 684 of 700 | wanning
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=wanning&units=metric
    Processing city 685 of 700 | lichuan
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=lichuan&units=metric
    Processing city 686 of 700 | misratah
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=misratah&units=metric
    Processing city 687 of 700 | mangrol
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=mangrol&units=metric
    Processing city 688 of 700 | aksarka
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=aksarka&units=metric
    Processing city 689 of 700 | narnaul
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=narnaul&units=metric
    Processing city 690 of 700 | hof
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=hof&units=metric
    Processing city 691 of 700 | kulhudhuffushi
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=kulhudhuffushi&units=metric
    Processing city 692 of 700 | obluche
    Data for obluche not found.
    Processing city 693 of 700 | batken
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=batken&units=metric
    Processing city 694 of 700 | nirmal
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=nirmal&units=metric
    Processing city 695 of 700 | puri
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=puri&units=metric
    Processing city 696 of 700 | mullaitivu
    Data for mullaitivu not found.
    Processing city 697 of 700 | batagay-alyta
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=batagay-alyta&units=metric
    Processing city 698 of 700 | felidhoo
    Data for felidhoo not found.
    Processing city 699 of 700 | rydultowy
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=rydultowy&units=metric
    Processing city 700 of 700 | voskresenskoye
    http://api.openweathermap.org/data/2.5/weather?appid=da015cf534cbe2d698015acc069c1e9e&q=voskresenskoye&units=metric
    ------------------------
    Data Retrieval Complete
    ------------------------
    


```python
summary = ["name", "clouds.all", "sys.country", "dt", "main.humidity", "coord.lat", "coord.lon", "main.temp_max", "wind.speed"]
data = [response(*summary) for response in weather_data]
column_names = ["City", "Cloudiness", "Country", "Date", "Humidity", "Latitude", "Longitude", "Max Temperature","Wind Speed"]
weather_data = pd.DataFrame(data, columns=column_names)
weather_data.to_csv("weather_data.csv", sep=',', encoding='utf-8', index = False)
weather_data.count()
```




    City               635
    Cloudiness         635
    Country            635
    Date               635
    Humidity           635
    Latitude           635
    Longitude          635
    Max Temperature    635
    Wind Speed         635
    dtype: int64




```python
weather_data.head(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>City</th>
      <th>Cloudiness</th>
      <th>Country</th>
      <th>Date</th>
      <th>Humidity</th>
      <th>Latitude</th>
      <th>Longitude</th>
      <th>Max Temperature</th>
      <th>Wind Speed</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Punta Arenas</td>
      <td>40</td>
      <td>CL</td>
      <td>1527822000</td>
      <td>75</td>
      <td>-53.16</td>
      <td>-70.91</td>
      <td>6.00</td>
      <td>7.20</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rikitea</td>
      <td>8</td>
      <td>PF</td>
      <td>1527823870</td>
      <td>100</td>
      <td>-23.12</td>
      <td>-134.97</td>
      <td>24.53</td>
      <td>0.86</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Arraial do Cabo</td>
      <td>0</td>
      <td>BR</td>
      <td>1527823870</td>
      <td>96</td>
      <td>-22.97</td>
      <td>-42.02</td>
      <td>21.28</td>
      <td>7.46</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Georgetown</td>
      <td>75</td>
      <td>GY</td>
      <td>1527822000</td>
      <td>94</td>
      <td>6.80</td>
      <td>-58.16</td>
      <td>25.00</td>
      <td>3.10</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Puerto Ayora</td>
      <td>0</td>
      <td>EC</td>
      <td>1527823871</td>
      <td>100</td>
      <td>-0.74</td>
      <td>-90.35</td>
      <td>22.83</td>
      <td>4.96</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Hermanus</td>
      <td>92</td>
      <td>ZA</td>
      <td>1527823872</td>
      <td>98</td>
      <td>-34.42</td>
      <td>19.24</td>
      <td>12.03</td>
      <td>7.71</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Mataura</td>
      <td>0</td>
      <td>NZ</td>
      <td>1527823872</td>
      <td>73</td>
      <td>-46.19</td>
      <td>168.86</td>
      <td>7.73</td>
      <td>2.06</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Lebu</td>
      <td>80</td>
      <td>ET</td>
      <td>1527823873</td>
      <td>97</td>
      <td>8.96</td>
      <td>38.73</td>
      <td>8.98</td>
      <td>1.26</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Avarua</td>
      <td>75</td>
      <td>CK</td>
      <td>1527822000</td>
      <td>88</td>
      <td>-21.21</td>
      <td>-159.78</td>
      <td>24.00</td>
      <td>2.60</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Chuy</td>
      <td>92</td>
      <td>UY</td>
      <td>1527823873</td>
      <td>98</td>
      <td>-33.69</td>
      <td>-53.46</td>
      <td>15.68</td>
      <td>9.11</td>
    </tr>
  </tbody>
</table>
</div>



# Max Temperature vs. Latitude Plot


```python
import datetime
date = datetime.datetime.fromtimestamp(int(weather_data["Date"][0])).strftime('%m/%d/%Y')

temps = weather_data["Max Temperature"]
lat = weather_data["Latitude"]
plt.scatter(x = lat, y = temps, marker="o")
plt.grid()
plt.title(f"Max Temperature vs Latitude ({date})")
plt.xlabel("Latitude")
plt.ylabel("Max Temperature")
plt.show()
```


![png](output_10_0.png)


# Humidity vs. Latitude Plot


```python
humid = weather_data["Humidity"]
plt.scatter(x = lat, y = humid, marker="o")
plt.grid()
plt.title(f"Humidity vs Latitude ({date})")
plt.xlabel("Latitude")
plt.ylabel("Humidity (%)")
plt.show()
```


![png](output_12_0.png)


# Cloudiness vs. Latitude Plot


```python
cloudy = weather_data["Cloudiness"]
plt.scatter(x = lat, y = cloudy, marker="o")
plt.grid()
plt.title(f"Cloudiness vs Latitude ({date})")
plt.xlabel("Latitude")
plt.ylabel("Cloudiness (%)")
plt.show()
```


![png](output_14_0.png)


# Wind Speed vs. Latitude Plot


```python
windspd = weather_data["Wind Speed"]
plt.scatter(x = lat, y = windspd, marker="o")
plt.grid()
plt.title(f"Wind Speed vs Latitude ({date})")
plt.xlabel("Latitude")
plt.ylabel("Wind Speed (mph)")
plt.show()
```


![png](output_16_0.png)

