angular
    .module('statsControllers', ['commonServices'])
    .controller(
	    'sumupStatsCtrl',
	    [
	        '$scope',
	        'myResources',
	        function ($scope, myResources) {
	        	$scope.test = myResources.records.get();
	        }
	    ]
	)
	.controller(
		'contentStatsCtrl',
		[
			 '$scope',
			 function ($scope) {
			 }
		]
	);