courseWeb = angular.module 'courseWebApp', [
    'ngAnimate',
    'ngAria',
    'ngRoute',
    'ui.router'
]

courseWeb.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/started'
    $stateProvider.state('main',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
    ).state('main.index',
        url: '/index'
        templateUrl: 'views/index.html'
        controller: 'IndexCtrl'
    ).state('main.admin',
        url: '/admin'
        templateUrl: 'views/admin.html'
        controller: 'AdminCtrl'
    ).state('main.started',
        url: '/started'
        templateUrl: 'views/started.html'
        controller: 'StartedCtrl'
    )