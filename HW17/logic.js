var queryUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

// Create a map object
var myMap = L.map("map", {
  center: [37.09, -95.71],
  zoom: 5
});

L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
  attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
  maxZoom: 18,
  id: "mapbox.streets-basic",
  accessToken: API_KEY
}).addTo(myMap);

// Perform a GET request to the query URL
d3.json(queryUrl, function(data) {
  // Once we get a response, send the data.features object to the createFeatures function
  createFeatures(data.features);
});
// Define a markerSize function that will give each city a different radius based on its population
function markerSize(mag) {
  return mag * 50000;
}
function chooseColor(mag) {
  if((0 <= mag) && (mag <= 1)){
    return "#99ff33";
  }
  if((1 < mag) && (mag <= 2)){
    return "#ccff33";
  }
  if((2 < mag) && (mag <= 3)){
    return "#ffff00";
  }
  if((3 < mag) && (mag <= 4)){
    return "#ffcc00";
  }
  if((4 < mag) && (mag <= 5)){
    return "#ff6600";
  }
  if(5 < mag){
    return "#cc0000";
  }
  return("white");
}
function createFeatures(earthquakeData) {

  // Loop through the cities array and create one marker for each city object
for (var i = 0; i < earthquakeData.length; i++) {
  L.circle([earthquakeData[i].geometry.coordinates[1],earthquakeData[i].geometry.coordinates[0]], {
    fillOpacity: 0.75,
    color: "black",
    weight: 2,
    fillColor: chooseColor(earthquakeData[i].properties.mag),
    // Setting our circle's radius equal to the output of our markerSize function
    // This will make our marker's size proportionate to its population
    radius: markerSize(earthquakeData[i].properties.mag)
  }).bindPopup("<h3>" + earthquakeData[i].properties.place +
  "</h3><hr><p>" + new Date(earthquakeData[i].properties.time) + "</p><p>Magnitude: " + earthquakeData[i].properties.mag + "</p>").addTo(myMap);
}
  // Setting up the legend
  var legend = L.control({ position: "bottomright" });
  legend.onAdd = function() {
    var div = L.DomUtil.create("div", "info legend");
    var limits = [0,1,2,3,4,5];
    var colors = ["#99ff33", "#ccff33", "#ffff00", "#ffcc00", "#ff6600", "#cc0000"];
    var labels = [];

    // Add min & max
    var legendInfo = "<h1>Magnitude</h1>" +
      "<div class=\"labels\">" +
        "<div class=\"min\">" + limits[0] + "</div>" +
        "<div class=\"max\">" + limits[limits.length - 1] + "</div>" +
      "</div>";

    div.innerHTML = legendInfo;

    limits.forEach(function(limit, index) {
      labels.push("<li style=\"background-color: " + colors[index] + "\"></li>");
    });

    div.innerHTML += "<ul>" + labels.join("") + "</ul>";
    return div;
  };

  // Adding legend to the map
  legend.addTo(myMap);

}

