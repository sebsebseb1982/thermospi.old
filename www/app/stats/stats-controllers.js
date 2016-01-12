angular
    .module('statsControllers', ['chartSerieServices', 'resourceServices', 'highcharts-ng', 'lodash'])
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
            '$q',
            'temperatureResources',
            'temperatureSeries',
            'averageTemperatureSeries',
            'statusSeries',
            'sunriseResources',
            'sunriseSerie',
            function ($scope, $q, temperatureResources, temperatureSeries, averageTemperatureSeries, statusSeries, sunriseResources, sunriseSerie) {

                $q.all([
                    temperatureResources.records.get().$promise,
                    temperatureResources.sensors.get().$promise,
                    temperatureResources.setpoints.get().$promise,
                    temperatureResources.status.get().$promise,
                    sunriseResources.sunrise.get().$promise
                ]).then(function (data) {

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

                        series: temperatureSeries.get(data[0], data[1], data[2]),
                        title: {
                            text: 'Températures'
                        },
                        loading: false,
                        xAxis: {
                            type: 'datetime',
                            plotBands: [statusSeries.get(data[3]), sunriseSerie.get(data[4])]
                        },
                        useHighStocks: false,
                        size: {
                            height: 500
                        },
                        func: function (chart) {
                        }
                    };
                });

                $q.all([
                    temperatureResources.averageInside.get().$promise,
                    temperatureResources.averageOutside.get().$promise
                ]).then(function (data) {

                    $scope.averageTermperaturesConfig = {
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

                        series: averageTemperatureSeries.get(data[0], data[1]),
                        title: {
                            text: 'Moyenne mensuelle'
                        },
                        loading: false,
                        xAxis: {
                            type: 'datetime'
                        },
                        useHighStocks: false,
                        size: {
                            height: 300
                        },
                        func: function (chart) {
                        }
                    };
                });


            }
        ]
    );