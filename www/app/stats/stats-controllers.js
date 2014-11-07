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
			 '_',
			 function ($scope, myResources, _) {
				 var records = myResources.records.get().$promise.then(function(records) {
					var test1 = _.map(
						_.filter(records, {sensorId:1}),
						function(record) {
							return [Date.parse(record.date), record.value];
						}
					);
					var test2 = _.map(
							_.filter(records, {sensorId:2}),
							function(record) {
								return [Date.parse(record.date), record.value];
							}
					);
					var test3 = _.map(
							_.filter(records, {sensorId:3}),
							function(record) {
								return [Date.parse(record.date), record.value];
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
							series: [{
								data: test1
							},{
								data: test2
							},{
								data: test3
							}],
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