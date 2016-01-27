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
        $scope.project = null
        $scope.groupForm =
            studentId: ""
        $scope.projectForm =
            name: ''
            refUrl: ''
            type: 'Android'
            description: ''

        $scope.group = Group
        $scope.hasGroup = () ->
            Group.members.length > 0

        $scope.changeState = (state) ->
            $scope.state = state


        $scope.$watch('state', (newValue, oldValue) ->
            if newValue == 'index'
                Chart.renderCommitCharts()
            else if newValue == 'editProject'
                $scope.prepareEditProject()
            else if newValue == 'editGroup'
                $scope.prepareEditGroup())

        $scope.createGroup = () ->
            Student.createGroup($scope.groupForm.studentId).then ((data) ->
                Materialize.toast("建立團隊成功", 2000)
            ), (msg) ->
                Materialize.toast(msg, 2000)

        $scope.destroyGroup = () ->
            Student.destroyGroup().then ((data) ->
                Materialize.toast("解散團隊成功", 2000)
            ), (msg) ->
                Materialize.toast(msg, 2000)


        $scope.createProject = () ->
            Student.createProject(
                $scope.projectForm.name,
                $scope.projectForm.refUrl,
                $scope.projectForm.type,
                $scope.projectForm.description
            ).then ((data) ->
                Materialize.toast("建立專案成功", 2000)
            ), (msg) ->
                Materialize.toast(msg, 2000)

        $scope.editProject = () ->
            Student.editProject(
                $scope.projectForm.name,
                $scope.projectForm.refUrl,
                $scope.projectForm.type,
                $scope.projectForm.description
            ).then ((data) ->
                Materialize.toast("修改專案成功", 2000)
            ), (msg) ->
                Materialize.toast(msg, 2000)


        $scope.prepareEditGroup = () ->
            $timeout(() ->
                $('.modal-trigger').leanModal();
            )
            Student.showGroup().then (data) ->

        $scope.prepareEditProject = () ->
            $scope.renderSelect()
            Student.showProject().then (data) ->
                $scope.project = data
                $scope.projectForm.name = $scope.project.name
                $scope.projectForm.refUrl = $scope.project.ref_url
                $scope.projectForm.type = $scope.project.project_type
                $scope.projectForm.description = $scope.project.description



        $scope.renderSelect = () ->
            $timeout(() ->
                $('select').material_select()
            ,300)

        $scope.renderNavBar = () ->
            $timeout(() ->
                $(".button-collapse").sideNav();
            )

        Chart.renderCommitCharts()
        $scope.renderSelect()
        $scope.renderNavBar()

]