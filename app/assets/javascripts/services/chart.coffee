angular.module('courseWebApp').factory 'Chart', [
    '$http',
    '$q',
    '$timeout'
    ($http, $q, $timeout) ->
        factory = {}
        factory.selfCommitTimes = []
        factory.highStandardCommitTimes = []
        factory.lowStandardCommitTimes = []
        factory.standardCommitTimes = []
        factory.commitChartElement = '#commitChart'
        factory.locChartElement = '#locChart'
        factory.timelogChartElement = '#timelogChart'

        factory.chartInformation = (title, unit, selfValue, standardValues, highStandardValues, lowStandardValues) ->
            title:
                text: title,
                x: -20
            subtitle:
                text: '',
                x: -20
            xAxis:
                categories: ['1', '2', '3', '4', '5', '6',
                    '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18']
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
            }]
        factory.renderCommitCharts = () ->
            $timeout(() ->
                $(factory.commitChartElement).highcharts(
                    factory.chartInformation('Commit 次數', '次數', factory.selfCommitTimes, factory.standardCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
                $(factory.locChartElement).highcharts(
                    factory.chartInformation('程式行數', '行', factory.selfCommitTimes, factory.standardCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
                $(factory.timelogChartElement).highcharts(
                    factory.chartInformation('時間', '小時', factory.selfCommitTimes, factory.standardCommitTimes,
                        factory.highStandardCommitTimes, factory.lowStandardCommitTimes)
                )
            )
        factory
]