angular
    .module(
    'commonServices',
    ['ngResource']
)
    .factory(
    'myResources', [
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
                    })
            }
        }
    ])
