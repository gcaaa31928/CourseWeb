courseWeb = angular.module 'courseWebApp', [
    'ngAnimate',
    'ngAria',
    'ngRoute',
    'ui.router',
    'ngStorage'
]

courseWeb.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/started'
    $stateProvider.state('main',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
    ).state('main.login',
        url: '/login'
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
    ).state('main.admin',
        url: '/admin'
        templateUrl: 'views/admin.html'
        controller: 'AdminCtrl'
    ).state('main.started',
        url: '/started'
        templateUrl: 'views/started.html'
        controller: 'StartedCtrl'
    ).state('main.student',
        url: '/student'
        templateUrl: 'views/student.html'
        controller: 'StudentCtrl'
    ).state('main.forgot_password',
        url: '/forgot_password?token'
        templateUrl: 'views/forgot_password.html'
        controller: 'ForgotPasswordCtrl'
    )