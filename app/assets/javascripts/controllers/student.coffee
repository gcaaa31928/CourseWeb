angular.module('courseWebApp').controller 'StudentCtrl', [
    '$scope',
    'Student',
    'Group',
    '$timeout',
    'Chart',
    ($scope, Student, Group, $timeout, Chart) ->
        # hack it
        $scope.isLogin = true
        $scope.state = 'index'
        $scope.project =
            timelog:
                null
        $scope.groupCreateForm =
            studentId: ""
        $scope.hasGroup = Group.members.length > 0


        $scope.changeState = (state) ->
            $scope.state = state
            if state == 'index'
                Chart.renderCommitCharts()
            else if state == 'editProject'
                $scope.renderSelect()
            else if state == 'editGroup'
                $scope.prepareEditGroup()

        $scope.createGroup = () ->
            # TODO(Red): adapte api

        $scope.renderSelect = () ->
            $timeout(() ->
                $('select').material_select()
            )

        $scope.prepareEditGroup = () ->
            Student.showGroup().then (data) ->
                console.log(data)

        Chart.renderCommitCharts()
        $scope.renderSelect()
]