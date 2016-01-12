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

                return {
                    records: $resource("http://192.168.1.50:3000/api/records", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    sensors: $resource("http://192.168.1.50:3000/api/sensors", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    status: $resource("http://192.168.1.50:3000/api/status", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    setpoints: $resource("http://192.168.1.50:3000/api/setpoints", null,
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
                    averageInside: $resource("http://192.168.1.50:3000/api/records/avg/inside", null,
                        {
                            get: {
                                method: 'GET',
                                isArray: true
                            }
                        }),
                    averageOutside: $resource("http://192.168.1.50:3000/api/records/avg/outside", null,
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
                    sunrise: $resource("http://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400&formatted=0", null,
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
