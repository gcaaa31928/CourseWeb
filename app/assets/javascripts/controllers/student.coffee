angular.module('courseWebApp').controller 'StudentCtrl', [
    '$scope',
    'Student',
    '$timeout',
    'Chart',
    ($scope, Student, $timeout, Chart) ->
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
                Chart.renderCommitCharts()
            else if state == 'editProject'
                $scope.renderSelect()
        $scope.createGroup = () ->
            # TODO(Red): adapte api

        $scope.renderSelect = () ->
            $timeout(() ->
                $('select').material_select()
            )

        Chart.renderCommitCharts()
        $scope.renderSelect()
]