# Copyright 2014 YMC. See LICENSE for details.

class @ShowRegionView extends Backbone.View

  initialize: ->
    @regionMetricCharts = []
    @$(".region-metric-chart-view").each (idx, element) =>
      @regionMetricCharts.push @createRegionMetricChartView(@$(element))

    @visualCountDown = new VisualCountDownView
      el: @$(".refresh-text")
      pattern: "(next refresh in %delay% seconds)"
    @visualCountDown.on "done", _.bind(@updateMetrics, @)
	
    @updateMetrics()

  createRegionMetricChartView: ($el) ->
    metrics = Metrics.byTargetAndNames($el.data("region-name"), $el.data("metric-names"))
    view = new MetricChartView
      el: $el
      collection: metrics
      annotatedMetricName: "compactions"
      annotationLabel: "Compaction"
      doNormalize: true
    view

  updateMetrics: ->
    view.collection.fetch() for view in @regionMetricCharts
    @visualCountDown.startCountDown(60, 1, 1000)

