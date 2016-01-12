angular
    .module(
        'chartServices',
        ['resourceServices']
    )
    .factory(
        'temperatureChart',
        [
            'temperatureResources',
            function ($resource) {
            }
        ]
    );
