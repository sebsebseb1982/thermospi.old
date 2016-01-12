angular
    .module('statsControllers', ['chartSerieServices', 'highcharts-ng', 'lodash'])
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
            'temperatureSeries',
            'statusSeries',
            function ($scope, temperatureSeries, statusSeries) {
                $scope.termperaturesConfig = {
                    options: {
                        chart: {
                            type: 'spline'
                        },
                        tooltip: {
                            style: {
                                padding: 10,
                                fontWeight: 'bold'
                            }
                        }
                    },

                    //Series object (optional) - a list of series using normal highcharts series options.
                    series: temperatureSeries.get(),
                    //Title configuration (optional)
                    title: {
                        text: 'Températures'
                    },
                    //Boolean to control showng loading status on chart (optional)
                    loading: false,
                    //Configuration for the xAxis (optional). Currently only one x axis can be dynamically controlled.
                    //properties currentMin and currentMax provied 2-way binding to the chart's maximimum and minimum
                    xAxis: {
                        type: 'datetime',
                        plotBands: statusSeries.get()
                    },
                    //Whether to use HighStocks instead of HighCharts (optional). Defaults to false.
                    useHighStocks: false,
                    //size (optional) if left out the chart will default to size of the div or something sensible.
                    size: {
                        height: 500
                    },
                    //function (optional)
                    func: function (chart) {
                        //setup some logic for the chart
                    }
                };
            }
        ]
    );