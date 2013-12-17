_DB = null
getDb = ->
  ### 获取数据库对象 ###
  if not _DB
    _DB = window.openDatabase('urls', '1.0', 'sample', 1024*1024*4)
    _DB.transaction((tx)->
      tx.executeSql('create table if not exists t_urls(c TEXT PRIMARY KEY,
i,h,k,m,l,n,s,u,t,v,b)')
    )
  _DB

_URLS = {}
findUrl = (code, fun)->
  ### 根据代码获取URL ###
  if code of _URLS
    fun(_URLS[code])
  else
    db = getDb()
    db.transaction((tx)->
      tx.executeSql('select u from t_urls where c=?', [code], (tx, rs)->
        if rs.rows.length > 0
          url = rs.rows.item(0)['u']
          _URLS[code] = url
          fun(url)
        else
          fun(null)
      )
    )

queryDb = (fun)->
  ### 获取数据 ###
  db = getDb()
  db.transaction((tx)->
    tx.executeSql('select max(i) as c from t_urls', [], (tx, rs)->
      i = 0
      max = 0
      while i < rs.rows.length
        if rs.rows.item(i)['c']
          max = rs.rows.item(i)['c']
        i++
      fun(max)
    )
  )

saveDb = (items)->
  ### 保存数据 ###
  db = getDb()
  db.transaction((tx)->
    for i in items
      tx.executeSql("delete from t_urls where c=?", [i.c])
    for i in items
      if i.a == '1'
        tx.executeSql("insert into t_urls(c,i,h,k,m,l,n,s,u,t,v,b)
  values (?,?,?,?,?,?,?,?,?,?,?,?)",
        [i.c, i.i, i.h, i.k, i.m, i.l, i.n, i.s, i.u, i.t, i.v, i.b])
  )

urlsCount = (fun)->
  ### 统计数量 ###
  db = getDb()
  db.transaction((tx)->
    tx.executeSql('select count(1) as c from t_urls', [], (tx, rs)->
      i = 0
      max = 0
      while i < rs.rows.length
        if rs.rows.item(i)['c']
          max = rs.rows.item(i)['c']
        i++
      fun(max)
    )
  )
findUrls = (fun)->
  ### 查找所有 ###
  db = getDb()
  db.transaction((tx)->
    tx.executeSql('select * from t_urls
 order by t, v desc', [], (tx, rs)->
      ret = []
      i = 0
      while i < rs.rows.length
        url = rs.rows.item(i)
        ret.push(url)
        i++
      fun(ret)
    )
  )
