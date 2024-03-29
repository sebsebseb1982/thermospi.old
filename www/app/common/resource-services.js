angular
    .module(
        'resourceServices',
        ['ngResource']
    )
    .factory(
        'temperatureResources',
        [
            '$resource',
            function ($resource) {

                var apiPath = "http://82.244.81.177:53254/api";

                return {
                    records: $resource(apiPath + "/records", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    lastRecords: $resource(apiPath + "/records/last", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    sensors: $resource(apiPath + "/sensors", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    status: $resource(apiPath + "/status", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    lastStatus: $resource(apiPath + "/status/last", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    setpoints: $resource(apiPath + "/setpoints", null,
                        {
                            post: {
                                method: 'POST',
                                params: {
                                    action: "rafraichissement"
                                }
                            },
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    averageInside: $resource(apiPath + "/records/avg/inside", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    averageOutside: $resource(apiPath + "/records/avg/outside", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        })
                }
            }
        ]
    )
    .factory(
        'sunriseResources',
        [
            '$resource',
            function ($resource) {
                return {
                    sunrise: $resource("http://api.sunrise-sunset.org/json?lat=44.806054&lng=-0.5853062&formatted=0", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: false
                            }
                        })
                }
            }
        ]
    );
