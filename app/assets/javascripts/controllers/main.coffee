angular.module('courseWebApp').controller 'MainCtrl', [
    '$scope',
    '$timeout',
    'Student',
    'Admin',
    '$state'
    ($scope, $timeout, Student, Admin, $state) ->
        $scope.layout = {}
        $scope.layout.sidebar = false
        $scope.layout.loading = false


        $timeout ->
            header = new Headhesive('.banner',
                classes:
                    clone: 'banner--clone'
                    stick: 'banner--stick'
                    unstick: 'banner--unstick'
            )
]