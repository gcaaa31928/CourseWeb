angular.module('courseWebApp').factory 'Chart', [
    '$http',
    '$q',
    '$timeout',
    'Student'
    ($http, $q, $timeout, Student) ->
        factory = {}
        factory.selfCommitTimes = []
        factory.highStandardCommitTimes = []
        factory.lowStandardCommitTimes = []
        factory.averageCommitTimes = []

        factory.selfLOC = []
        factory.highStandardLOC = []
        factory.lowStandardLOC = []
        factory.averageLOC = []

        factory.selfTimelog = []
        factory.highStandardTimelog = []
        factory.lowStandardTimelog = []
        factory.averageTimelog = []

        factory.commitChartElement = '#commitChart'
        factory.locChartElement = '#locChart'
        factory.timelogChartElement = '#timelogChart'

        remoteDataToChartsData = (data) ->
            chart_logs = []
            for key, value of data
                chart_log = [Date.parse(key), value]
                chart_logs.push(chart_log)
            chart_logs

        factory.getCommitsChart = () ->
            $q (resolve, reject) ->
                Student.showCommitsChart().then ((data) ->
                    factory.selfCommitTimes = remoteDataToChartsData(data.you)
                    factory.averageCommitTimes = remoteDataToChartsData(data.average)
                    factory.highStandardCommitTimes = remoteDataToChartsData(data.high_standard)
                    factory.lowStandardCommitTimes = remoteDataToChartsData(data.low_standard)
                    Student.showLocChart().then ((data) ->
                        factory.selfLOC = remoteDataToChartsData(data.you)
                        factory.averageLOC = remoteDataToChartsData(data.average)
                        factory.highStandardLOC = remoteDataToChartsData(data.high_standard)
                        factory.lowStandardLOC = remoteDataToChartsData(data.low_standard)
                        Student.showTimelogChart().then ((data) ->
                            factory.selfTimelog = remoteDataToChartsData(data.you)
                            factory.averageTimelog = remoteDataToChartsData(data.average)
                            factory.highStandardTimelog = remoteDataToChartsData(data.high_standard)
                            factory.lowStandardTimelog = remoteDataToChartsData(data.low_standard)
                            resolve()
                        ), (msg) ->
                            resolve()
                    ), (msg) ->
                        resolve()
                ), (msg) ->
                    resolve()

        factory.chartInformation = (title, unit, selfValue, standardValues, highStandardValues, lowStandardValues) ->
            chart: {
                type: 'area',
                spacingBottom: 30
            }
            title:
                text: title,
                x: -20
            subtitle:
                text: '',
                x: -20
            xAxis:
                type: 'datetime'
                dateTimeLabelFormats:
                    day: '%e. %b'
            yAxis:
                title:
                    text: unit
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            legend:
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            series: [{
                name: '高標',
                data: highStandardValues
            }, {
                name: '均標',
                data: standardValues
            }, {
                name: '低標',
                data: lowStandardValues
            }, {
                name: '你',
                data: selfValue
                lineWidth: 3
            }]
            credits: {
                enabled: false
            }
        factory.renderCommitCharts = () ->

            $timeout(() ->
                $(factory.commitChartElement).highcharts(
                    factory.chartInformation('Commit 次數', '次數', factory.selfCommitTimes, factory.averageCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
                $(factory.locChartElement).highcharts(
                    factory.chartInformation('程式行數', '行', factory.selfLOC, factory.averageLOC,
                        factory.highStandardLOC, factory.lowStandardLOC)
                )
                console.log(factory.averageTimelog)
                $(factory.timelogChartElement).highcharts(
                    factory.chartInformation('時間', '小時', factory.selfTimelog, factory.averageTimelog,
                        factory.highStandardTimelog, factory.lowStandardTimelog)
                )
            )
        factory
]