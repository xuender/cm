_gaq = _gaq || []
_gaq.push(['_setAccount', 'UA-35761644-1'])
_gaq.push(['_trackPageview'])

analytics = ->
  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = 'https://ssl.google-analytics.com/ga.js'
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore(ga, s)

if JU.lsGet('analytics', true)
  analytics()

$ ->
  $(document).on('click', 'a', ->
    if $(this).attr('id')
      _gaq.push(['_trackEvent', 'a', $(this).attr('id')])
    true
  )

