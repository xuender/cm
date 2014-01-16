((i, s, o, g, r, a, m)->
  if JS.lsGet('analytics', true)
    i['GoogleAnalyticsObject'] = r
    i[r] = i[r] || ->
      (i[r].q = i[r].q || []).push(arguments)
    i[r].l = 1 * new Date()
    a = s.createElement(o)
    m = s.getElementsByTagName(o)[0]
    a.async = 1
    a.src = g
    m.parentNode.insertBefore(a, m)
  else
    window['ga'] = ->
      console.debug arguments
)(window, document, 'script', 'https://w.google-analytics.com/analytics.js', 'ga')
ga('create', 'UA-35761644-1')
ga('send', 'pageview')

