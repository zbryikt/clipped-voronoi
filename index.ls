<- $(document).ready

[w,h] = [800,600]
data = [0 til 20]map (idx)->
  [x,y] = [Math.random!*w, Math.random!*h]
  {x,y,idx}
force = d3.layout.force!size [800,600] .nodes data

voronoi = d3.geom.voronoi!.clipExtent [[0,0], [w,h]] .x(->it.x) .y(->it.y)
svg = d3.select \svg
circle = svg.selectAll \circle .data(data,->it.idx) .enter! .append \circle 
path = svg.selectAll \path.voronoi .data voronoi(data) .enter!append \path .attr \class, \voronoi

[count,rx,ry] = [360, 100, 100]
ext = d3.geom.polygon([0 til count].map(-> [
  400 + rx * Math.cos(3.14 * (360/count) * it / 180),
  300 - ry * Math.sin(3.14 * (360/count) * it / 180)
]))

redraw = ->
  circle.attr do
    cx: -> it.x
    cy: -> it.y
    r: 2
  path.data(voronoi(data).map(->ext.clip(d3.geom.polygon(it))).filter(->it.length)).attr do
    stroke: \#000
    "stroke-width": \1
    fill: "rgba(0,0,0,0.1)"
    d: -> "M#{it.join(\L)}Z"
  force.alpha 0.101

force.on \tick, redraw .start!
