###
# QR码、短网址、快递工具
###
queryKd = (num, tab, back, incognito)->
  ### 根据快递单号查找快递信息 ###
  xmlhttp = new XMLHttpRequest()
  xmlhttp.open('GET',
    "http://www.kuaidi100.com/autonumber/auto?num=#{num}", true)
  xmlhttp.setRequestHeader('Content-Type', 'application/json')
  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState == 4 and xmlhttp.status != 0
      response = JSON.parse(xmlhttp.responseText)
      for r in response
        show("http://www.kuaidi100.com/chaxun?com=#{r.comCode}&nu=%s",
          num, tab, back, incognito)

  xmlhttp.send()
  1
copy2Clipboard = (str)->
  ### 复制到剪贴板 ###
  input = document.getElementById('url')
  if input == undefined
    return
  input.value = str
  input.select()
  document.execCommand('copy', false, null)

readClipboard = ->
  ### 读取剪贴板 ###
  input = document.getElementById('url')
  if input == undefined
    return
  input.select()
  document.execCommand('paste')
  input.value

createUrl = ->
  ### 创建url对象 ###
  input = document.createElement('input')
  input.type = 'text'
  input.id = 'url'
  document.body.appendChild(input)
createUrl()
createQR = (value, tab, back, incognito)->
  ### 生成QR码 ###
  size = JU.lsGet('qr_size', 250)
  show("http://chart.apis.google.com/chart?chs=#{size}x#{size}&cht=qr&chl=%s",
    value, tab, back, incognito)
qrcode.callback = (str)->
  ### QR码解析回调函数 ###
  if /\w{3,}:\/\/*/.test(str)
    chrome.tabs.create(url: str)
  else
    alert(str)
copyResponse = (response)->
  ### 复制剪贴板回调函数 ###
  if response.status == 'error'
    alert('response error')
  else
    copy2Clipboard(response.message)
alertResponse = (response)->
  ### 弹出回调函数 ###
  if response.status == 'error'
    alert('response error')
  else
    alert(response.message)
shortenUrlCopy = (url, tab, back, incognito)->
  ### 短网址复制剪贴板 ###
  shortenUrl(url, false, copyResponse)
shortenUrlAlert = (url, tab, back, incognito)->
  ### 短网址弹出 ###
  shortenUrl(url, false, alertResponse)
shortenUrl = (longUrl, incognito, callback)->
  ### 生成短网址 ###
  name = JU.lsGet('shorten', 'googl')
  switch name
    when 'dwz' then dwz(longUrl, incognito, callback)
    when 'sinat' then sinat(longUrl, incognito, callback)
    when 'urlcn' then urlcn(longUrl, incognito, callback)
    else googl(longUrl, incognito, callback)
  _gaq.push(['_trackEvent', 'shorten', name])
urlcn = (longUrl, incognito, callback)->
  ### 腾讯短网址 ###
  xmlhttp = new XMLHttpRequest()
  url = "http://open.t.qq.com/api/short_url/shorten?format=json&long_url=#{encodeURIComponent(longUrl)}&appid=801399639&openkey=898eab772e8dbd603f03c4db1963de93"
  xmlhttp.open('GET', url, false)
  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState == 4 and xmlhttp.status != 0
      response = JSON.parse(xmlhttp.responseText)
      if response.errcode == 102
        alert response.msg
      else
        callback(
          status: 'success'
          message: "http://url.cn/#{response['data']['short_url']}"
        )
  xmlhttp.send()
sinat = (longUrl, incognito, callback)->
  ### 新浪短网址 ###
  xmlhttp = new XMLHttpRequest()
  url = "http://api.t.sina.com.cn/short_url/shorten.json?source=1144650722&url_long=#{encodeURIComponent(longUrl)}"
  xmlhttp.open('GET', url, false)
  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState == 4 and xmlhttp.status != 0
      response = JSON.parse(xmlhttp.responseText)
      if response.error_code == 500
        alert response.error
      else
        callback(
          status: 'success'
          message: response[0]['url_short']
        )
  xmlhttp.send()
dwz = (longUrl, incognito, callback)->
  ### 百度短网址 ###
  xmlhttp = new XMLHttpRequest()
  xmlhttp.open('POST',
    'http://dwz.cn/create.php', true)
  xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState == 4 and xmlhttp.status != 0
      response = JSON.parse(xmlhttp.responseText)
      callback(
        status: 'success'
        message: response.tinyurl
      )
  xmlhttp.send("url=#{encodeURIComponent(longUrl)}")
  
googl = (longUrl, incognito, callback)->
  ### Google 短网址 ###
  auth = getOauth().hasToken() and !incognito
  xmlhttp = new XMLHttpRequest()
  xmlhttp.open('POST',"#{URL}?key=#{KEY}", true)
  xmlhttp.setRequestHeader('Content-Type', 'application/json')
  if auth
    xmlhttp.setRequestHeader('Authorization',
      oauth.getAuthorizationHeader(URL, 'POST', {'key': KEY}))

  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState == 4 and xmlhttp.status != 0
      response = JSON.parse(xmlhttp.responseText)

      if response.id == undefined
        if response.error.code == '401'
          oauth.clearTokens()
        callback({status: 'error', message: response.error.message})
        console.error('error:%s', response.error.message)
      else
        callback(
          status: 'success'
          message: response.id
          added_to_history: auth
        )

  xmlhttp.send(JSON.stringify('longUrl': longUrl))

KEY = 'AIzaSyAfKgyjoxWmR4RJyRhmk0X-J7q2WB9TbGA'
TIMER = null
URL = 'https://www.googleapis.com/urlshortener/v1/url'
getOauth = ->
  ### 获取oauth对象 ###
  if !window.OAUTH
    window.OAUTH = ChromeExOAuth.initBackgroundPage(
      'request_url' : 'https://www.google.com/accounts/OAuthGetRequestToken'
      'authorize_url' : 'https://www.google.com/accounts/OAuthAuthorizeToken'
      'access_url' : 'https://www.google.com/accounts/OAuthGetAccessToken'
      'consumer_key' : '293074347131.apps.googleusercontent.com'
      'consumer_secret' : '2AtwN_96VFpevnorbSWK8czI'
      'scope' : 'https://www.googleapis.com/auth/urlshortener'
      'app_name' : 'Right search menu'
    )
  window.OAUTH

tabClose = (value, tab, back, incognito)->
  ### 关闭标签页 ###
  console.info('关闭:' + tab.id)
  chrome.tabs.remove(tab.id)
