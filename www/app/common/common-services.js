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
                records: $resource("http://192.168.1.50:3000/api/temperatures/records", null,
                    {
                        get: {
                            method: 'GET',
                        	isArray: true
                        }
                    })/*,
                coordonnees: $resource('/cv-api/:idRCI/coordonnees',
                    {
                        idRCI: $stateParams.idRCI
                    },
                    {
                        get: {
                            method: 'GET',
                            cache: cacheFactory
                        }
                    })*/
            }
        }
    ])
