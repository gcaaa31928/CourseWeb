angular.module('courseWebApp').factory 'Group' ,[
    () ->
        # data = [{'id' => 104598038, 'name' => nil}]
        factory = {}
        factory.members = []
        factory.processData = (dataClusters) ->
            factory.members = dataClusters

        factory.handleAllGroup = (data) ->
            data.sort (a,b) ->
                if a.projectName? and b.projectName?
                    return a.id - b.id
                else if not a.projectName and not b.projectName?
                    return a.id - b.id
                else if a.projectName?
                    return -1
                else if b.projectName?
                    return 1

            data


        factory
]