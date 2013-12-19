###
# 字符集转换
###
encoden = (str)->
  ### GBK编码 使用%u替换 ###
  escape(str).replace('+', '%u002B')
encodeToGbk = (str)->
  ### 编码Gbk ###
  JU.gbkEncodeURI(str)
encodeToBig5 = (str)->
  ### 编码Big5 ###
  JU.big5EncodeURI(str)
#httpEncode = (str, en)->
#  ### 编码 ###
#  xmlhttp = new XMLHttpRequest()
#  xmlhttp.open('GET',
#    'http://emap.sinaapp.com/encode?k=' +
#    encodeURIComponent(str) + '&s=' + en, false)
#  ret = ''
#  xmlhttp.setRequestHeader('Content-Type', 'text/plain')
#  xmlhttp.onreadystatechange = ->
#    if xmlhttp.readyState == 4 and xmlhttp.status != 0
#      ret = xmlhttp.responseText
#  xmlhttp.send()
#  ret
