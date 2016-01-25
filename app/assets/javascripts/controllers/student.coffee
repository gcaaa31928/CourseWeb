angular.module('courseWebApp').controller 'StudentCtrl', [
    '$scope',
    'Student',
    '$timeout'
    ($scope, Student, $timeout) ->
        # hack it
        $scope.isLogin = true
        $scope.state = 'index'
        $scope.project =
            timelog:
                null
        $scope.group = Student.group
        $scope.groupCreateForm =
            studentId: ""


        $scope.changeState = (state) ->
            $scope.state = state
            if state == 'index'
                $scope.renderChart()
        $scope.createGroup = () ->
            # TODO(Red): adapte api

        $scope.renderChart = () ->
            $timeout(() ->
                chart = Highcharts.chart('chart', series: [ { data: [
                    1
                    3
                    2
                    4
                ] } ])
            )
        $scope.renderChart()

]