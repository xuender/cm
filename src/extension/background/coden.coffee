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
