angular
    .module(
        'chartSerieServices',
        []
    )
    .factory(
        'temperatureSeries',
        [
            '_',
            function (_) {
                var get = function (records, sensors, setpoints) {
                    var series = [];

                    // Courbes de température
                    _.forEach(
                        sensors,
                        function (sensor) {

                            var aTemperatureSerie = {
                                'name': sensor.label,
                                'data': _.map(_.filter(records, {sensorId: sensor.id}), function (record) {
                                    return [Date.parse(record.date), record.value];
                                })
                            };

                            series.push(aTemperatureSerie);
                        }
                    );

                    // Courbe des consignes de chauffe


                    var finalSetPoint = {
                        'id': setpoints[setpoints.length - 1].id,
                        'value': setpoints[setpoints.length - 1].value,
                        'date': new Date()
                    };
                    setpoints.push(finalSetPoint);

                    var setPointsSerie = {
                        'name': 'Consigne',
                        'step': true,
                        'color': '#FF4040',
                        'type': 'line',
                        'data': _.map(setpoints, function (setpoint) {
                            return [Date.parse(setpoint.date), setpoint.value];
                        })
                    };

                    series.push(setPointsSerie);

                    return series;
                };

                return {
                    get: get
                }
            }
        ]
    )
    .factory(
        'averageTemperatureSeries',
        [
            '_',
            function (_) {
                var get = function (inside, outside) {
                    var series = [];

                    var insideSerie = {
                        'name': 'Intérieur',
                        'color': '#90ED7D',
                        'type': 'line',
                        'data': _.map(inside, function (record) {
                            return [Date.parse(record.date), record.avg];
                        })
                    };

                    series.push(insideSerie);

                    var outsideSerie = {
                        'name': 'Extérieur',
                        'color': '#7CB5EC',
                        'type': 'column',
                        'data': _.map(outside, function (record) {
                            return [Date.parse(record.date), record.avg];
                        })
                    };

                    series.push(outsideSerie);

                    return series;
                };

                return {
                    get: get
                }
            }
        ]
    )
    .service(
        'statusSeries',
        [
            '_',
            function (_) {
                this.get = function (status) {
                    var getAPlotBand = function (from, to) {
                        return {
                            from: from,
                            to: to,
                            color: '#ffb3b3',
                            label: {
                                text: Math.floor((Math.abs(to - from) / 1000) / 60) + ' min.',
                                style: {
                                    color: '#606060'
                                },
                                verticalAlign: 'middle',
                                rotation: -90
                            },
                            zIndex: 2
                        }
                    };

                    var statusBands = [];
                    var from;
                    _.forEach(status, function (status) {
                        if (!from && status.status == 1) {
                            from = Date.parse(status.date);
                        } else if (from && status.status == 0) {
                            var to = Date.parse(status.date);
                            statusBands.push(getAPlotBand(from, to));
                            from = undefined;
                        }
                    });

                    if (from) {
                        statusBands.push(getAPlotBand(from, new Date()));
                    }

                    return statusBands;
                }
            }
        ]
    )
    .service(
    'sunriseSerie',
    [
        '_',
        function (_) {
            this.get = function (sunriseDetails) {

                var plotLines = [];

                plotLines.push({
                    color: 'rgba(255, 255, 204, 0.8)',
                    /*dashStyle: 'longdashdot',
                    value: Date.parse(sunriseDetails.results.sunset),
                    width: 2,*/
                    from:Date.parse(sunriseDetails.results.sunrise),
                    to:Date.parse(sunriseDetails.results.sunset),
                    label: {
                        text: "Jour",
                        style: {
                            color: '#606060'
                        },
                        verticalAlign: 'middle',
                        rotation: -90
                    },
                    zIndex: 0
                });

                return plotLines;
            }
        }
    ]
);
