// from data.js
var tableData = data;

// Select the submit button
var submit = d3.select("#filter-btn");

submit.on("click", function() {

    d3.event.preventDefault();
    var inputElement = d3.select("#datetime");

  // Get the value property of the input element
    var inputValue = inputElement.property("value");

    console.log(inputValue);
    console.log(tableData);

    var filteredData = tableData.filter(sighting => sighting.datetime === inputValue);

    console.log(filteredData);

  // gather table elements
  var date = filteredData.map(sighting => sighting.datetime);
  var city = filteredData.map(sighting => sighting.city);
  var state = filteredData.map(sighting => sighting.state);
  var country = filteredData.map(sighting => sighting.country);
  var shape = filteredData.map(sighting => sighting.shape);
  var duration = filteredData.map(sighting => sighting.durationMinutes);
  var comment = filteredData.map(sighting => sighting.comments);

  filteredData.forEach((sighting) => {
    console.log(sighting);
    d3.select("#ufo-table").append("tr")
    // Get the entries for each object in the array
    Object.entries(sighting).forEach(([key, value]) => {
      // Log the key and value
      console.log(`Key: ${key} and Value ${value}`);
      d3.select("#ufo-table")
        .append("th").text(`${value}`)
    });
  });
//   d3.select("#ufo-table")
//     .append("tr").text(`${date}`)
//     .append("tr").text(`${city}`)
//     .append("tr").text(`${state}`)
//     .append("tr").text(`${country}`)
//     .append("tr").text(`${shape}`)
//     .append("tr").text(`${duration}`)
//     .append("tr").text(`${comment}`);
});

