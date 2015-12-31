# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Helper method for date validation
@dateFormatValid = (date) ->
  moment(date, 'DD/MM/YYYY', true).isValid()        

# Main Hours React Component  
@Hours = React.createClass
  getInitialState: ->               # Generate the initial state of our component
    hours: @props.data              # to use sent Records data.
  getDefaultProps: ->               # Initialize component properties in case no data is sent when instantiating it.
    hours: []
  addHour: (hour) ->
    hours = React.addons.update(@state.hours, { $push: [hour] })
    @setState hours: hours
  deleteHour: (hour) ->
    index = @state.hours.indexOf hour
    hours = React.addons.update(@state.hours, { $splice: [[index, 1]] })
    @replaceState hours: hours  
  updateHour: (hour, data) ->
    index = @state.hours.indexOf hour
    hours = React.addons.update(@state.hours, { $splice: [[index, 1, data]] })
    @replaceState hours: hours
  render: ->
    React.DOM.div null, 
      # Render .csv download button 
      React.DOM.a
        className: 'btn btn-default btn-xs pull-right'
        href: '../hours.csv'
        title: 'Download as a .csv file'
        React.DOM.span
          className: 'glyphicon glyphicon-download-alt'
          'aria-hidden': 'true'
        ' .csv'
      React.createElement HourForm, handleNewHour: @addHour
      React.DOM.table 
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Client'
            React.DOM.th null, 'Project'
            React.DOM.th null, 'Date'
            React.DOM.th null, 'Hours'                      
        React.DOM.tbody null,
          for hour in @state.hours
            React.createElement Hour, key: hour.id, hour: hour, handleDeleteHour: @deleteHour, handleEditHour: @updateHour

@Hour = React.createClass
  getInitialState: ->
    edit: false
    client: @props.hour.client
    clientformclass: ''
    clientformicon: ''
    project: @props.hour.project
    projectformclass: ''
    projectformicon: ''
    date: moment(@props.hour.date).format('DD/MM/YYYY')
    dateformclass: ''
    dateformicon: ''
    hours: @props.hour.hours
    hoursformclass: ''
    hoursformicon: ''
  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit
  handleDelete: (e) ->
    if confirm "Are you sure you want to delete this record?"
      e.preventDefault()
      $.ajax
        method: 'DELETE'
        url: "/hours/#{ @props.hour.id }"
        dataType: 'JSON'
        success: () =>
          @props.handleDeleteHour @props.hour
          updateChart()
  handleEdit: (e) ->
    e.preventDefault()
    data =
      client: React.findDOMNode(@refs.client).value
      project: React.findDOMNode(@refs.project).value
      date: React.findDOMNode(@refs.date).value
      hours: React.findDOMNode(@refs.hours).value
    $.ajax
      method: 'PUT'
      url: "/hours/#{ @props.hour.id }"
      dataType: 'JSON'
      data:
        hour: data
      success: (data) =>
        @setState edit: false
        @props.handleEditHour @props.hour, data
        updateChart()
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value

  valid: ->
    @state.client && @state.project && dateFormatValid(@state.date) && @state.hours
         
  recordForm: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.DOM.input
          className: 'form-control input-sm'
          type: 'text'
          defaultValue: @props.hour.client
          ref: 'client'
          name: 'client'
          onChange: @handleChange 

      React.DOM.td null,
        React.DOM.input
          className: 'form-control input-sm'
          type: 'text'
          defaultValue: @props.hour.project
          #defaultValue: @state.project
          ref: 'project'
          name: 'project'
          onChange: @handleChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control input-sm'
          type: 'text'
          defaultValue: moment(@props.hour.date).format('DD/MM/YYYY')
          #defaultValue: @state.date
          ref: 'date'
          name: 'date'
          onChange: @handleChange
      React.DOM.td null,
        React.DOM.input
          className: 'form-control input-sm'
          type: 'text'
          defaultValue: @props.hour.hours
          #defaultValue: @state.hours
          ref: 'hours'
          name: 'hours'
          onChange: @handleChange

      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-success btn-xs'
          onClick: @handleEdit
          disabled: !@valid()
          'Update'
        React.DOM.a
          className: 'btn btn-warning btn-xs'
          onClick: @handleToggle
          'Cancel'
  recordRow: ->
    React.DOM.tr null,
      React.DOM.td null, @props.hour.client 
      React.DOM.td null, @props.hour.project
      React.DOM.td null, moment(@props.hour.date).format('DD/MM/YYYY')
      React.DOM.td null, @props.hour.hours      
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-primary btn-xs'
          onClick: @handleToggle
          'Edit' 
        React.DOM.a
          className: 'btn btn-danger btn-xs'
          onClick: @handleDelete
          'Delete'
  render: ->
    if @state.edit
      @recordForm()
    else
      @recordRow()

@HourForm = React.createClass
  getInitialState: ->
    client: ''
    clientformclass: 'form-group has-feedback'    
    clientformicon: 'form-control-feedback'  
    project: ''
    projectformclass: 'form-group has-feedback'    
    projectformicon: 'form-control-feedback'      
    date: ''
    dateformclass: 'form-group has-feedback'    
    dateformicon: 'form-control-feedback'      
    hours: ''
    hoursformclass: 'form-group has-feedback'    
    hoursformicon: 'form-control-feedback'  
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
  handleStringChange: (e) ->
    name = e.target.name
    value = e.target.value
    @setState "#{ name }": value
    if value
      @setState "#{ name }formclass": 'form-group has-success has-feedback' 
      @setState "#{ name }formicon": 'form-control-feedback glyphicon glyphicon-ok'
    else
      @setState "#{ name }formclass": 'form-group has-feedback' 
      @setState "#{ name }formicon": 'form-control-feedback glyphicon'
  handleDateChange: (e) ->
    name = e.target.name
    value = e.target.value
    @setState "#{ name }": value
    if dateFormatValid(value)
      @setState "#{ name }formclass": 'form-group has-success has-feedback' 
      @setState "#{ name }formicon": 'form-control-feedback glyphicon glyphicon-ok'
    else
      @setState "#{ name }formclass": 'form-group has-feedback' 
      @setState "#{ name }formicon": 'form-control-feedback glyphicon'


  valid: ->  
    @state.client && @state.project && dateFormatValid(@state.date) && @state.hours
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '../hours/', { hour: @state }, (data) =>
      @props.handleNewHour data
      @setState @getInitialState()
    , 'JSON'
    # Pause for data write to catch up before updating chart 
    setTimeout (->
      updateChart()
      return
    ), 1000        
  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: @state.clientformclass 
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Client'
          name: 'client'
          value: @state.client
          onChange: @handleChange
          onInput: @handleStringChange          
          'aria-describedby': 'inputclientstatus'
        React.DOM.span
          className: @state.clientformicon # 'glyphicon glyphicon-ok form-control-feedback'
          'aria-hidden': 'true'
        React.DOM.span
          id: 'inputclientstatus' 
          className: 'sr-only'
          '(success)'
      React.DOM.div
        className: @state.projectformclass
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Project'
          name: 'project'
          value: @state.project
          onChange: @handleChange
          onInput: @handleStringChange                    
          'aria-describedby': 'inputprojectstatus'
        React.DOM.span
          className: @state.projectformicon
          'aria-hidden': 'true'
        React.DOM.span
          id: 'inputprojectstatus' 
          className: 'sr-only'
          '(success)'
      React.DOM.div
        className: @state.dateformclass
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Date (dd/mm/yyyy)'
          name: 'date'
          value: @state.date
          onChange: @handleChange
          onInput: @handleDateChange                              
          'aria-describedby': 'inputdatestatus'
        React.DOM.span
          className: @state.dateformicon
          'aria-hidden': 'true'
        React.DOM.span
          id: 'inputdatestatus' 
          className: 'sr-only'
          '(success)'          
      React.DOM.div
        className: @state.hoursformclass
        React.DOM.input
          type: 'number'
          className: 'form-control'
          placeholder: 'Hours'
          name: 'hours'
          value: @state.hours
          onChange: @handleChange
          onInput: @handleStringChange                                        
          'aria-describedby': 'inputprojectstatus'
        React.DOM.span
          className: @state.hoursformicon
          'aria-hidden': 'true'
        React.DOM.span
          id: 'inputprojectstatus' 
          className: 'sr-only'
          '(success)'

      React.DOM.div
        className: 'form-group '
        React.DOM.button
          type: 'submit'
          className: 'btn btn-primary'
          disabled: !@valid()
          'Create'

@drawChart = (location) ->
  d3.select('svg').remove()
  parseDateTime = d3.time.format("%Y-%m-%d").parse  
  path = []
  dot = []

  # Define chart dimensions 
  margin = 
    top: 10
    right: 60
    bottom: 100
    left: 50
  width = 500 - (margin.left) - (margin.right)
  height = 500 - (margin.top) - (margin.bottom)
  x = d3.time.scale().range([0, width])
  y = d3.scale.linear().range([height, 0])


  # Define the axes
  xAxis = d3.svg.axis().scale(x).orient('bottom')
  yAxis = d3.svg.axis().scale(y).orient('left').ticks(10)

  svg = d3.select('#chart')
  .append('svg')
  .attr('width', width + margin.left + margin.right)
  .attr('height', height + margin.top + margin.bottom)
  .append('g')
  .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')


  # Initialise tooltip 
  tooltip = d3.select("#chart")
  .append("div")
  .attr("class", "tooltip")
  .style("opacity", 0);

  # Define the line
  valueline = d3.svg.line().x((d) ->
    x new Date(d.date)
  ).y((d) ->
    y d.hours
  ).interpolate("linear")

  # Get the data
  d3.json '../hours.json', (error, data) ->
    data.forEach (d) ->
      d.date = parseDateTime(d.date)
      d.client = d.client
      d.project = d.project
      d.hours = +d.hours

    data = data.sort (a, b) ->
      d3.ascending a.date, b.date

    singleData = data[0]

    x.domain(d3.extent(singleData, (d) ->        
      new Date(d.date)
    )).nice()
    y.domain(d3.extent(singleData, (d) ->
      d.hours
    )).nice()

    svg.append('g')
    .attr('class', 'x axis')
    .attr('transform', 'translate(0,' + height + ')')
    .call(xAxis)
    .selectAll("text")
    .attr("y", 0)
    .attr("x", 9)
    .attr("dy", ".35em")
    .attr("transform", "rotate(90)")
    .style("text-anchor", "start")


    svg.append('g')
    .attr('class', 'y axis')
    .call(yAxis)
    .append('text')
    .attr('class', 'label')
    .attr('transform', 'rotate(-90)')
    .attr('y', 6)
    .attr('dy', '.71em')
    .style('text-anchor', 'end')
    .text('Hours')


    # Add the valueline path.
    path = svg.append("path")
    .attr("class", "line")
    .attr("d", valueline(singleData))



    dot = svg.selectAll('.dot')
    .data(singleData)
    .enter()
    .append('circle')
    .attr('class', (d) ->
      'dot ' + d.client + ' ' + d.project
    )
    .attr('r', 2)
    .attr('cx', (d) ->
      x new Date(d.date)
    ).attr('cy', (d) ->
      y d.hours
    )
    .on 'mouseover', (d) ->
      tooltip.transition()
      .duration(200)
      .style("opacity", .9)        
      tooltip.html(moment(d.date).format('DD/MM/YYYY') + " - " + d.client + " - " + d.hours )
      .style("left", (d3.event.pageX - 10) + "px")
      .style("top", (d3.event.pageY - 60) + "px")
    .on 'mouseout', (d) ->
      tooltip.transition()
      .duration(200)
      .style("opacity", 0)
    updateChart()


  @updateChart = (location) ->
    
    # Get the data
    d3.json '../hours.json', (error, newData) ->
      newData.forEach (d) ->
        d.date = parseDateTime(d.date)
        d.client = d.client
        d.project = d.project
        d.hours = +d.hours

      newData = newData.sort (a, b) ->
        d3.ascending a.date, b.date

      x.domain(d3.extent(newData, (d) ->        
        new Date(d.date)
      )).nice()
      y.domain(d3.extent(newData, (d) ->
        d.hours
      )).nice()

      svg.transition()
      .select(".y.axis") 
      .duration(750)
      .call(yAxis);

      svg.transition()
      .select(".x.axis") 
      .duration(750)
      .call(xAxis)
      .selectAll("text")
      .attr("y", 0)
      .attr("x", 9)
      .attr("dy", ".35em")
      .attr("transform", "rotate(90)")
      .style("text-anchor", "start")

      path.transition()
      .duration(2000)
      .ease("linear")
      .attr("class", "line")
      .attr("d", valueline(newData))

      svg.selectAll('.dot').remove()

      dot = svg.selectAll('.dot')
      .data(newData)
      .enter()
      .append('circle')
      #.attr('class', 'dot')
      .attr('class', (d) ->
        return 'dot ' + d.client + ' ' + d.project
      )
      .attr('r', 2)
      .attr('cx', (d) ->
        x new Date(d.date)
      ).attr('cy', (d) ->
        y d.hours                                                                 
      )
      .on 'mouseover', (d) ->
        tooltip.transition()
        .duration(200)
        .style("opacity", .9)        
        tooltip.html(moment(d.date).format('DD/MM/YYYY') + " - " + d.client + " - " + d.hours )
        .style("left", (d3.event.pageX - 10) + "px")
        .style("top", (d3.event.pageY - 60) + "px")
      .on 'mouseout', (d) ->
        tooltip.transition()
        .duration(200)
        .style("opacity", 0)

      dot.style("opacity", 0)
      .transition()
      .duration(4000)
      .style("opacity", 1)      



ready = ->
  drawChart()
  #window.setInterval(drawChart, 1000);


$(document).ready(ready)
$(document).on('page:load', ready)






