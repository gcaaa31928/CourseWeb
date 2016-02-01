angular.module('courseWebApp').controller 'AdminCtrl', [
    '$scope',
    'Admin',
    'Group',
    '$q'
    ($scope, Admin, Group, $q) ->
        q = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)

        courseQuery = async.queue(((task, callback) ->
            task().then () ->
                callback()
        ), 1)

        $scope.inCourse = false;
        $scope.inCreatingCourse = false;
        $scope.loading = false
        $scope.courseLoading = false
        $scope.courses = null
        $scope.requestLoading = false
        $scope.selectedCourse = null
        $scope.groups = null
        $scope.studentsWithoutGroup = null

        $scope.createCourse = () ->

            $scope.inCreatingCourse = true
            $scope.inCourse = false

        $scope.form =
            courseId: ""


        $scope.submitCreateCourse = () ->
            $scope.requestLoading = true
            Admin.createCourseStudent($scope.form.courseId).then ((data) ->
                Materialize.toast("建立專案成功", 2000)
                $scope.prepareCourse()
                $scope.requestLoading = false
            ), (msg) ->
                Materialize.toast(msg, 2000)
                $scope.requestLoading = false

        $scope.selectCourse = (course) ->
            $scope.inCreatingCourse = false
            $scope.inCourse = true
            $scope.selectedCourse = course
            $scope.prepareSelectedCourse(course)

        q.drain = () ->
            $scope.layout.loading = false

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

        $scope.prepareSelectedCourse = (course) ->
            $scope.courseLoading = true
            courseQuery.push($scope.prepareAllGroup)
            courseQuery.push($scope.prepareListStudentWithoutGroup)


        $scope.prepareAll = () ->
            $scope.layout.loading = true
            q.push($scope.prepareCourse)

        $scope.prepareAll()


]