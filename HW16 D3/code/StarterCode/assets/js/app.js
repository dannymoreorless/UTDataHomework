// @TODO: YOUR CODE HERE!
//set up chart
var svgWidth = 960;
var svgHeight = 500;

var margin = {
  top: 20,
  right: 40,
  bottom: 60,
  left: 50
};

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;


//append SVG group to hold chart
var svg = d3
  .select("#scatter")
  .append("svg")
  .attr("width", svgWidth)
  .attr("height", svgHeight);

var chartGroup = svg.append("g")
  .attr("transform", `translate(${margin.left}, ${margin.top})`);

//import data
d3.csv(`https://raw.githubusercontent.com/the-Coding-Boot-Camp-at-UT/UTAUS201804DATA2-Class-Repository-DATA/master/16-D3/HOMEWORK/Instructions/data/data.csv?token=Ai1PAo1JB9BhLSmKznD5hrahNdD9xkZ3ks5beJe9wA%3D%3D`).then(success,error);

function error(error){
    throw error;
};

function success(healthdata){

  // Step 1: Create scale functions
  // ==============================
  var xLinearScale = d3.scaleLinear()
    .domain([8, 23])
    .range([0, width]);

  var yLinearScale = d3.scaleLinear()
    .domain([2, 28])
    .range([height, 0]);

  // Step 2: Create axis functions
  // ==============================
  var bottomAxis = d3.axisBottom(xLinearScale);
  var leftAxis = d3.axisLeft(yLinearScale);

  // Step 3: Append Axes to the chart
  // ==============================
  chartGroup.append("g")
    .attr("transform", `translate(0, ${height})`)
    .call(bottomAxis);

  chartGroup.append("g")
    .call(leftAxis);

   // Step 4: Create Circles
  // ==============================
  var circlesGroup = chartGroup.selectAll("circle")
  .data(healthdata)
  .enter()
  .append("circle")
  .attr("cx", d => xLinearScale(d.poverty))
  .attr("cy", d => yLinearScale(d.healthcare))
  .attr("r", "14")
  .attr("fill", "lightblue")
  .attr("alpha", "0.5");

  //
  chartGroup.append("g").selectAll("text")
    .data(healthdata)
    .enter()
    .append("text")
    .text(function (d) {
    return d.abbr;
    })
    .attr("dx", d => xLinearScale(d.poverty))
    .attr("dy", d => yLinearScale(d.healthcare)+5)
    .attr("class","stateText");
  // Step 5: Initialize tool tip
  // ==============================
  var toolTip = d3.tip()
    .attr("class", "tooltip")
    .offset([0, 0])
    .html(function(d) {
      return (`<b>${d.state}</b><br>Healthcare: ${d.healthcare}%<br>Poverty: ${d.poverty}%`);
    });

  // Step 6: Create tooltip in the chart
  // ==============================
  chartGroup.call(toolTip);

  // Step 7: Create event listeners to display and hide the tooltip
  // ==============================
  circlesGroup.on("click", function(data) {
    toolTip.show(data);
  })
    // onmouseout event
    .on("mouseout", function(data, index) {
      toolTip.hide(data);
    });

  // Create axes labels
  chartGroup.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left - 3)
    .attr("x", 0 - (height/1.5))
    .attr("dy", "1em")
    .attr("class", "axisText")
    .attr("font-weight","bold")
    .text("Lacks Healthcare (%)");

  chartGroup.append("text")
    .attr("transform", `translate(${width / 2}, ${height + margin.top + 30})`)
    .attr("class", "axisText")
    .attr("font-weight","bold")
    .text("In Poverty (%)");
};