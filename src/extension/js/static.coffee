###
static.coffee
Copyright (C) 2013 ender xu <xuender@gmail.com>

a: status
c: ucode
n: name
s: sha1
u: url
v: visits
b: black
h: title
m: mode
t: type
l: hl
k: nick
i: update time

Distributed under terms of the MIT license.
###

STATIC = [
  {
    c: "google_pic"
    m: "PIC"
    l: "all"
    n: "Google Images"
    u: "http://www.google.com/searchbyimage?image_url=%s"
    t: "all"
  }
  {
    c: "baidu"
    h: "百度一下，你就知道"
    m: "TXT"
    l: "zh_CN"
    n: "百度"
    u: "http://www.baidu.com/s?wd=%s"
    t: "all"
  }
  {
    c: "baidu_pic"
    m: "PIC"
    l: "zh_CN"
    n: "百度图片"
    u: "http://stu.baidu.com/i?rt=0&rn=10&ct=1&tn=baiduimage&objurl=%s"
    t: "all"
  }
  {
    c: "i_title"
    m: "MEN"
    l: "all"
    n: "Context Menus Option"
    u: "options.html"
    t: "all"
  }
  {
    c: "google"
    m: "TXT"
    l: "all"
    n: "Google"
    u: "https://www.google.com/search?q=%s"
    t: "all"
  }
  {
    c: "bing"
    m: "TXT"
    l: "all"
    n: "Bing"
    u: "http://www.bing.com/search?q=%s"
    t: "all"
  }
  {
    c: "google_link"
    m: "LIN"
    l: "all"
    n: "Google link"
    u: "https://www.google.com/search?q=link%3A%s"
    t: "all"
  }
  {
    c: "google_site"
    m: "LIN"
    l: "all"
    n: "Google site"
    u: "https://www.google.com/search?q=site%3A%s"
    t: "all"
  }
  {
    c: "bing_site1"
    m: "TXT"
    l: "all"
    n: "Bing Site Search"
    u: "http://www.bing.com/search?q=site%3A%u+%s"
    t: "all"
  }
  {
    c: "Yahoo"
    m: "TXT"
    l: "en"
    n: "Yahoo"
    u: "http://search.yahoo.com/search?p=%s"
    t: "all"
  }
  {
    c: "google_define"
    m: "TXT"
    l: "all"
    n: "Google Definition"
    u: "http://www.google.com/search?hl=en&q=define:%s"
    t: "all"
    b: 0
  }
  {
    c: "c_extensions"
    m: "MEN"
    l: "all"
    n: "Extensions"
    u: "chrome://extensions/"
    t: "chrome"
  }
  {
    c: "c_downloads"
    m: "MEN"
    l: "all"
    n: "Downloads"
    u: "chrome://downloads/"
    t: "chrome"
  }
  {
    c: "c_settings"
    m: "MEN"
    l: "all"
    n: "Settings"
    u: "chrome://settings/"
    t: "chrome"
  }
  {
    c: "c_flags"
    m: "MEN"
    l: "all"
    n: "Flags"
    u: "chrome://flags/"
    t: "chrome"
  }
  {
    c: "c_history"
    m: "MEN"
    l: "all"
    n: "History"
    u: "chrome://history/"
    t: "chrome"
  }
  {
    c: "c_clearBD"
    m: "MEN"
    l: "all"
    n: "Clear browsing data"
    u: "chrome://settings/clearBrowserData"
    t: "chrome"
  }
  {
    c: "c_bookmarks"
    m: "MEN"
    l: "all"
    n: "Bookmark Manager"
    u: "chrome://bookmarks/#1"
    t: "chrome"
  }
  {
    c: "c_plugins"
    m: "MEN"
    l: "all"
    n: "Plug-ins"
    u: "chrome://plugins/"
    t: "chrome"
  }
  {
    c: "c_version"
    m: "MEN"
    l: "all"
    n: "About Version"
    u: "chrome://version/"
    t: "chrome"
  }
  {
    c: "c_memory"
    m: "MEN"
    l: "en"
    n: "About Memory"
    u: "chrome://memory-redirect/"
    t: "chrome"
  }
  {
    c: "c_credits"
    m: "MEN"
    l: "en"
    n: "Credits"
    u: "chrome://credits/"
    t: "chrome"
  }
  {
    c: "translate"
    m: "TXT"
    l: "all"
    n: "Google Translate"
    u: "http://translate.google.com/?q=%s"
    t: "fy"
  }
  {
    c: "youtube"
    m: "TXT"
    l: "all"
    n: "youtube"
    u: "http://www.youtube.com/results?search_query=%s"
    t: "movie"
  }
  {
    c: "taobao"
    m: "TXT"
    l: "zh_CN"
    n: "淘宝"
    u: "http://s8.taobao.com/search?q=%g&bucket_id=11&pid=mm_31528417_3400431_10960519"
    t: "shop"
  }
  {
    c: "amazon"
    m: "TXT"
    l: "zh_CN"
    n: "亚马逊中国"
    u: "http://www.amazon.cn/search/search.asp?source=xuender-23&searchType=&searchWord=%s&Submit.x=8&Submit.y=4&Submit=Go"
    t: "shop"
  }
  {
    c: "Amazon_com"
    m: "TXT"
    l: "en"
    n: "Amazon"
    u: "http://www.amazon.com/gp/associates/link-types/searchbox.html?tag=ender0f-20&keyword=%s"
    t: "shop"
  }
  {
    c: "gmail_lin"
    m: "LIN"
    l: "all"
    n: "Send with Gmail"
    u: "https://mail.google.com/mail/?view=cm&fs=1&source=mailto&body=%s&tf=1"
    t: "sns"
  }
  {
    c: "weibo_lin"
    m: "LIN"
    l: "zh_CN"
    n: "新浪微博"
    u: "http://service.weibo.com/share/share.php?url=%s&appkey=1144650722"
    t: "sns"
  }
  {
    c: "weibo_txt"
    m: "TXT"
    l: "zh_CN"
    n: "新浪微博"
    u: "http://service.weibo.com/share/share.php?appkey=1144650722&title=%s"
    t: "sns"
  }
  {
    c: "weibo"
    h: "当前页面分享到新浪微博"
    m: "MEN"
    l: "zh_CN"
    n: "新浪微博"
    u: "http://service.weibo.com/share/share.php?appkey=1144650722&url=%s"
    t: "sns"
  }
  {
    c: "weibo_pic"
    m: "PIC"
    l: "zh_CN"
    n: "新浪微博"
    u: "http://service.weibo.com/share/share.php?appkey=1144650722&pic=%s"
    t: "sns"
  }
  {
    c: "t_qq"
    m: "TXT"
    l: "zh_CN"
    n: "腾讯微博"
    u: "http://search.t.qq.com/index.php?k=%s"
    t: "sns"
  }
  {
    c: "facebook"
    m: "TXT"
    l: "all"
    n: "Facebook"
    u: "http://www.facebook.com/search/results.php?q=%s"
    t: "sns"
  }
  {
    c: "gmail_page"
    m: "MEN"
    l: "all"
    n: "Send with Gmail"
    u: "https://mail.google.com/mail/?view=cm&fs=1&tf=1&source=mailto&body=%s"
    t: "sns"
  }
  {
    c: "google_plus"
    m: "TXT"
    l: "all"
    n: "Google+"
    u: "https://plus.google.com/s/%s"
    t: "sns"
  }
  {
    c: "twitter"
    m: "TXT"
    l: "en"
    n: "twitter"
    u: "https://twitter.com/search?q=%s"
    t: "sns"
  }
  {
    c: "facebook_lin"
    m: "LIN"
    l: "all"
    n: "Facebook Share"
    u: "https://www.facebook.com/dialog/feed?app_id=365325133587367&redirect_uri=https%3A//www.facebook.com&link=%s"
    t: "sns"
  }
  {
    c: "facebook_menu"
    m: "MEN"
    l: "all"
    n: "Facebook Share"
    u: "https://www.facebook.com/dialog/feed?app_id=365325133587367&link=%s&redirect_uri=https%3A//www.facebook.com"
    t: "sns"
  }
  {
    c: "twitter_men"
    m: "MEN"
    l: "en"
    n: "Twitter Share"
    u: "https://twitter.com/intent/tweet?url=%s"
    t: "sns"
  }
  {
    c: "gmail_txt"
    m: "TXT"
    l: "all"
    n: "Send with Gmail"
    u: "https://mail.google.com/mail/?view=cm&fs=1&tf=1&body=%s&source=mailto"
    t: "sns"
  }
  {
    c: "gmail_pic"
    m: "PIC"
    l: "all"
    n: "Send with Gmail"
    u: "https://mail.google.com/mail/?view=cm&tf=1&source=mailto&body=%s&fs=1"
    t: "sns"
  }
  {
    c: "qzone"
    h: "当前页面分享到QQ空间"
    m: "MEN"
    l: "zh_CN"
    n: "分享到QQ空间"
    u: "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=%s&title=%l"
    t: "sns"
  }
  {
    c: "twitter_share"
    m: "TXT"
    l: "en"
    n: "Twitter Share"
    u: "https://twitter.com/intent/tweet?text=%s"
    t: "sns"
  }
  {
    c: "qr_lin"
    m: "LIN"
    l: "all"
    n: "Generates QR for link"
    u: "qr_lin"
    t: "utils"
  }
  {
    c: "qr_decode"
    m: "PIC"
    l: "all"
    n: "Parsing QR in the images"
    u: "qr_decode"
    t: "utils"
  }
  {
    c: "su_pic"
    m: "PIC"
    l: "all"
    n: "Create image short URL to clipboard"
    u: "su_pic"
    t: "utils"
  }
  {
    c: "wikipedia"
    m: "TXT"
    l: "zh_CN"
    n: "简体维基百科"
    u: "http://zh.wikipedia.org/wiki/Special:Search?search=%s"
    t: "utils"
  }
  {
    c: "qr"
    m: "MEN"
    l: "all"
    n: "Generates QR for page"
    u: "qr"
    t: "utils"
  }
  {
    c: "su_lin"
    m: "LIN"
    l: "all"
    n: "Create short URL of the link and copy"
    u: "su_lin"
    t: "utils"
  }
  {
    c: "qr_txt"
    m: "TXT"
    l: "all"
    n: "Generates QR for select text."
    u: "qr_txt"
    t: "utils"
  }
  {
    c: "su"
    m: "MEN"
    l: "all"
    n: "Create short URL to clipboard"
    u: "su"
    t: "utils"
  }
  {
    c: "qr_pic"
    m: "PIC"
    l: "all"
    n: "Generates QR for image"
    u: "qr_pic"
    t: "utils"
  }
  {
    c: "kd"
    m: "TXT"
    l: "zh_CN"
    n: "快递单查询"
    u: "kd"
    t: "utils"
  }
  {
    c: "ditu"
    m: "TXT"
    l: "zh_CN"
    n: "Google地图"
    u: "https://ditu.google.com/maps?hl=zh-cn&newwindow=1&q=%s"
    t: "utils"
  }
  {
    c: "su_lin_alert"
    m: "LIN"
    l: "all"
    n: "Create link Short URL"
    u: "su_lin_alert"
    t: "utils"
  }
  {
    c: "su_alert"
    m: "MEN"
    l: "all"
    n: "Create short URL"
    u: "su_alert"
    t: "utils"
  }
  {
    c: "en_wikipedia"
    m: "TXT"
    l: "en"
    n: "Wikipedia en"
    u: "http://en.wikipedia.org/wiki/Special:Search?search=%s"
    t: "utils"
  }
  {
    c: "map_baidu"
    m: "TXT"
    l: "zh_CN"
    n: "百度地图"
    u: "http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D%s"
    t: "utils"
  }
  {
    c: "su_pic_alert"
    m: "PIC"
    l: "all"
    n: "Create short URL for image"
    u: "su_pic_alert"
    t: "utils"
  }
]
_URLS = {}
findUrl = (code, fun)->
  ### 根据代码获取URL ###
  if code of _URLS
    fun(_URLS[code])
  else
    for s in STATIC
      if s.c == code
        _URLS[code] = s.u
        fun(url)
    fun(null)
