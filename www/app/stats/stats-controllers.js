angular
    .module('statsControllers', ['commonServices', 'highcharts-ng', 'lodash'])
    .controller(
	    'sumupStatsCtrl',
	    [
	        '$scope',
	        function ($scope) {
	        }
	    ]
	)
	.controller(
		'contentStatsCtrl',
		[
			 '$scope',
			 'myResources',
			 '$q',
			 '_',
			 function ($scope, myResources, $q, _) {
				 
				 
				$q.all([
					myResources.records.get().$promise,
					myResources.sensors.get().$promise
				]).then(function(data) {
					var records = data[0];
					var sensors = data[1];
					
					var series = [];
					
					_.forEach(
						sensors,
						function(sensor) {
							
							var newSerie = {
								'name' : sensor.label,
								'data' : _.map(_.filter(records, {sensorId:sensor.id}),function(record) {return [Date.parse(record.date), record.value];})
							};
							
							series.push(newSerie);
						}
					);
					
					$scope.termperaturesConfig = {
							options: {
								chart: {
									type: 'line'
								},
								tooltip: {
									style: {
										padding: 10,
										fontWeight: 'bold'
									}
								}
							},
							
							//The below properties are watched separately for changes.
							
							//Series object (optional) - a list of series using normal highcharts series options.
							series: series,
							//Title configuration (optional)
							title: {
								text: 'Hello'
							},
							//Boolean to control showng loading status on chart (optional)
							loading: false,
							//Configuration for the xAxis (optional). Currently only one x axis can be dynamically controlled.
							//properties currentMin and currentMax provied 2-way binding to the chart's maximimum and minimum
							xAxis: {
								type: 'datetime'
							},
							//Whether to use HighStocks instead of HighCharts (optional). Defaults to false.
							useHighStocks: false,
							//size (optional) if left out the chart will default to size of the div or something sensible.
							size: {
								width: 400,
								height: 300
							},
							//function (optional)
							func: function (chart) {
								//setup some logic for the chart
							}
					};
				});
			 }
		]
	);