import datetime as dt
import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify


#################################################
# Database Setup
#################################################
engine = create_engine('sqlite:///Resources/hawaii.sqlite', connect_args={'check_same_thread': False})

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"/api/v1.0/[YY-MM-DD]<br/>"
        f"/api/v1.0/[YY-MM-DD]/[YY-MM-DD]<br/>"
    )


@app.route("/api/v1.0/precipitation")
def precipitation():
    """Return a list of all precipitation data"""
    date = dt.datetime.now() - dt.timedelta(days=365)
# Perform a query to retrieve the data and precipitation scores
    sel = [Measurement.date, Measurement.prcp]

    results = session.query(*sel).\
        filter(Measurement.date > date).\
        order_by(Measurement.date).all()

    last_year = []
    for data in results:
        data_dict = {}
        data_dict[f"{data.date}"] = data.prcp
        # data_dict["precipitation"] = data.prcp
        last_year.append(data_dict)
    
    return jsonify(last_year)


@app.route("/api/v1.0/stations")
def stations():
    """Return a list of station data"""
    # Query all stations
    sel = [Station.station, Station.name,
           Station.latitude, Station.longitude,
           Station.elevation]

    results = session.query(*sel).all()

    all_stations = []
    for data in results:
        station_dict = {}
        station_dict["station"] = data.station
        station_dict["name"] = data.name
        station_dict["latitude"] = data.latitude
        station_dict["longitude"] = data.longitude
        station_dict["elevation"] = data.elevation
        all_stations.append(station_dict)

    return jsonify(all_stations)

@app.route("/api/v1.0/tobs")
def tobs():
    """Return a list of all tobs data"""
    date = dt.datetime.now() - dt.timedelta(days=365)
# Perform a query to retrieve the data and precipitation scores
    sel = [Measurement.date, Measurement.tobs]

    results = session.query(*sel).\
        filter(Measurement.date > date).\
        order_by(Measurement.date).all()

    last_year = []
    for data in results:
        data_dict = {}
        data_dict["date"] = data.date
        data_dict["temperature"] = data.tobs
        last_year.append(data_dict)

    return jsonify(last_year)

@app.route("/api/v1.0/<start_date>")
def start(start_date):
    """Fetch the Tmin, Tmax, and Tavg of the temperature observations
       from the start date."""
    sel = [func.max(Measurement.tobs), 
           func.min(Measurement.tobs),
           func.avg(Measurement.tobs)]
    results = session.query(*sel).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) >= start_date).all()

    return(jsonify(results))

@app.route("/api/v1.0/<start_date>/<end_date>")
def start_end(start_date, end_date):
    """Fetch the Tmin, Tmax, and Tavg of the temperature observations
       from the start date to the end date"""
    sel = [func.max(Measurement.tobs), 
           func.min(Measurement.tobs),
           func.avg(Measurement.tobs)]

    results = session.query(*sel).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) >= start_date).\
    filter(func.strftime("%Y-%m-%d", Measurement.date) <= end_date).all()

    return(jsonify(results))

if __name__ == '__main__':
    app.run(debug=True)
