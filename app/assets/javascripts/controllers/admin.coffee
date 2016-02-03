angular.module('courseWebApp').controller 'AdminCtrl', [
    '$scope',
    'Admin',
    'Group',
    '$q',
    '$timeout'
    ($scope, Admin, Group, $q, $timeout) ->
        q = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)

        courseQuery = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)
        $scope.state = 'course'
        $scope.inCourse = false;
        $scope.inCreatingCourse = false;
        $scope.loading = false
        $scope.courseLoading = false
        $scope.courses = null
        $scope.requestLoading = false
        $scope.selectedCourse = null
        $scope.selectedGroup = null
        $scope.groups = null
        $scope.timelogs = null
        $scope.studentsWithoutGroup = null
        $scope.addTeachingForm =
            id: ''
            name: ''
            className: ''
            courseId: ''


        $scope.changeState = (state) ->
            $scope.state = state


        $scope.$watch('state', (newValue, oldValue) ->
            #TODO(Red): nothing to do
            if newValue == 'manage'
                $scope.prepareManage()
        )



        $scope.createCourse = () ->

            $scope.inCreatingCourse = true
            $scope.inCourse = false

        $scope.form =
            courseId: ""

        $scope.timelogDate = ''


        $scope.submitCreateCourse = () ->
            $scope.requestLoading = true
            Admin.createCourseStudent($scope.form.courseId).then ((data) ->
                Materialize.toast("建立專案成功", 2000)
                $scope.prepareCourse()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.submitAddTeachingAssistant = () ->
            $scope.requestLoading = true
            Admin.addTeachingAssistant(
                $scope.addTeachingForm.id,
                $scope.addTeachingForm.name,
                $scope.addTeachingForm.className,
                $scope.addTeachingForm.courseId
            ).then ((data) ->
                Materialize.toast("增加助教成功", 2000)
                $scope.prepareManage()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false


        $scope.selectCourse = (course) ->
            $scope.inCreatingCourse = false
            $scope.inCourse = true
            $scope.selectedCourse = course
            $scope.prepareSelectedCourse(course)


        $scope.openTimelogModal = (group) ->
            $scope.selectedGroup = group
            Admin.showTimelog(group.project.id).then ((data) ->
                $scope.timelogs = data
                $timeout(() ->
                    $('#timelog-modal').openModal();
                )

            ), (msg) ->


        $scope.createTimelog = () ->
            $scope.requestLoading = true
            transferDate = $scope.picker.getDate().toUTCString()
            Admin.createTimelog(transferDate).then ((date) ->
                $scope.requestLoading = false
                Materialize.toast("新增Timelog成功", 2000)
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false


        q.drain = () ->
            $scope.layout.loading = false

        $scope.prepareManage = () ->
            $q (resolve, reject) ->
                $scope.loading = true
                Admin.listTeachingAssistants().then ((data) ->
                    $scope.teachingAssistants = data
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()

        $scope.prepareCourse = (course) ->
            $q (resolve, reject) ->
                $scope.loading = true
                Admin.allCourse().then ((data) ->
                    $scope.courses = data
                    $scope.loading = false
                    resolve()
                ), (msg) ->
                    $scope.loading = false
                    resolve()


        $scope.prepareAllGroup = () ->
            $q (resolve, reject) ->
                Admin.allGroup($scope.selectedCourse.id).then ((data) ->
                    $scope.groups = Group.handleAllGroup(data)
                    resolve()
                ), (msg) ->
                    resolve()

        $scope.prepareListStudentWithoutGroup = () ->
            $q (resolve, reject) ->
                Admin.listStudentWithoutGroup($scope.selectedCourse.id).then ((data) ->
                    $scope.studentsWithoutGroup = data
                    resolve()
                ), (msg) ->
                    resolve()

        courseQuery.drain = () ->
            $scope.courseLoading = false
            $timeout(() ->
                $scope.picker = new Pikaday({ field: $('#datepicker')[0] })
                $('.modal-trigger').leanModal();
            )

        $scope.prepareSelectedCourse = (course) ->
            $scope.courseLoading = true
            courseQuery.push($scope.prepareAllGroup)
            courseQuery.push($scope.prepareListStudentWithoutGroup)


        $scope.prepareAll = () ->
            $scope.layout.loading = true
            q.push($scope.prepareCourse)

        $scope.prepareAll()


]