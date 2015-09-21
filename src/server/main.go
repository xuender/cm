package main

import (
	"bytes"
	"encoding/gob"
	"github.com/gin-gonic/gin"
	"github.com/syndtr/goleveldb/leveldb"
	"log"
	"net/http"
)

var CACHE *Cache

type Cache struct {
	db *leveldb.DB
}

func (cache *Cache) Close() {
	cache.Close()
}
func (cache *Cache) Get(key string, value interface{}) error {
	bs, err := cache.db.Get([]byte(key), nil)
	if err != nil {
		return err
	}
	dec := gob.NewDecoder(bytes.NewBuffer(bs))
	return dec.Decode(value)
}
func (cache *Cache) Has(key string) bool {
	b, err := cache.db.Get([]byte(key), nil)
	return err == nil && len(b) > 0
}
func (cache *Cache) Set(key string, value interface{}) error {
	var bb bytes.Buffer
	enc := gob.NewEncoder(&bb)
	err := enc.Encode(value)
	if err == nil {
		return cache.db.Put([]byte(key), bb.Bytes(), nil)
	}
	return err
}

func (cache *Cache) Remove(key string) error {
	return cache.db.Delete([]byte(key), nil)
}
func NewCache(path string) *Cache {
	db, _ := leveldb.OpenFile(path, nil)
	ldb := Cache{
		db: db,
	}
	return &ldb
}

type Url struct {
	Name  string
	Url   string
	Nick  string
	Title string
	hl    string
	mode  string
}

func postUrl(c *gin.Context) {
	var url Url
	c.Bind(&url)
	log.Printf("url.Name:%s url.Url:%s", url.Name, url.Url)
	if CACHE.Has(url.Url) {
		c.JSON(http.StatusOK, "have")
		return
	}
	err := CACHE.Set(url.Url, url)
	if err == nil {
		c.JSON(http.StatusOK, "ok")
	} else {
		c.JSON(http.StatusOK, "error")
	}
}

// 读取设置
func getSettings(c *gin.Context) {
	phrase := c.DefaultQuery("phrase", "")
	if !CACHE.Has(phrase) {
		c.JSON(http.StatusOK, "phrase")
		return
	}
	var settings map[string]interface{}
	err := CACHE.Get(phrase, &settings)
	if err == nil {
		c.JSON(http.StatusOK, settings)
	} else {
		c.JSON(http.StatusOK, "error")
	}
}

// 保存设置
func postSettings(c *gin.Context) {
	phrase := c.DefaultQuery("phrase", "")
	if phrase == "" {
		c.JSON(http.StatusOK, "phrase")
		return
	}
	var settings map[string]interface{}
	c.Bind(&settings)
	err := CACHE.Set(phrase, settings)
	if err == nil {
		c.JSON(http.StatusOK, "ok")
	} else {
		c.JSON(http.StatusOK, "error")
	}
}

func main() {
	log.Printf("CM Start")
	CACHE = NewCache("cache")
	defer CACHE.Close()
	g := gin.Default() // 初始化web服务
	g.POST("/cm/url", postUrl)
	g.POST("/cm/settings", postSettings)
	g.GET("/cm/settings", getSettings)
	// 404
	g.NoRoute(func(c *gin.Context) {
		c.String(http.StatusNotFound, "404")
	})
	g.Run(":8011") // 服务器端口
}
