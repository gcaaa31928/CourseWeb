angular.module('courseWebApp').controller 'MainCtrl', [
    '$scope',
    '$timeout',
    'Student',
    '$state'
    ($scope, $timeout, Student, $state) ->
        $scope.layout = {}
        $scope.layout.sidebar = false
        $scope.layout.loading = false

        $scope.prepare = () ->
            if $state.current.name == 'main.started'
                return
            $scope.layout.loading = true
            Student.verifyAccessToken().then ((data) ->
                $scope.layout.loading = false
            ), (msg) ->
                $state.go('main.started')

        $scope.prepare()
        $timeout ->
            header = new Headhesive('.banner',
                classes:
                    clone: 'banner--clone'
                    stick: 'banner--stick'
                    unstick: 'banner--unstick'
            )
]