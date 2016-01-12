'use strict';

// Declare app level module which depends on views, and components
angular.module(
	'thermospiApp', 
	[
		'ui.router',
		'statsControllers',
		'chartSerieServices',
		'resourceServices'
	]
)
.config(
	[
	 	'$stateProvider', 
	 	function($stateProvider) {
			$stateProvider
			    .state('stats',
		    		{
				        url: '/',
				        views: {
				            'sumup': {
				                templateUrl: 'stats/partials/sumup.html',
				                controller: 'sumupStatsCtrl'
				            },
				            'content': {
				                templateUrl: 'stats/partials/content.html',
				                controller: 'contentStatsCtrl'
				            }
				        }
		    		}
			    );
	 	}
 	]
);
