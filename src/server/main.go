package main

import (
	"bytes"
	"encoding/gob"
	"encoding/json"
	"github.com/gin-gonic/gin"
	"github.com/robfig/cron"
	"github.com/syndtr/goleveldb/leveldb"
	"log"
	"net/http"
	"sort"
	"strings"
	//	"reflect"
)

var CACHE *Cache
var MENUS []Menu

type Menu struct {
	C string
	T string
	M string
	U string
	L string
	V int
}
type MenuList []Menu

func (list MenuList) Len() int {
	return len(list)
}
func (list MenuList) Less(i, j int) bool {
	return list[i].V > list[j].V
}
func (list MenuList) Swap(i, j int) {
	var temp Menu = list[i]
	list[i] = list[j]
	list[j] = temp
}

type Cache struct {
	db *leveldb.DB
}

func (cache *Cache) All() error {
	iter := cache.db.NewIterator(nil, nil)
	var menus []Menu
	for iter.Next() {
		key := iter.Key()
		log.Println(string(key))
		//value := iter.Value()
		var settings map[string]interface{}
		dec := gob.NewDecoder(bytes.NewBuffer(iter.Value()))
		dec.Decode(&settings)
		//json.Unmarshal(str.([]byte), &settings)
		str, ok := settings["all"]
		var all []Menu
		if ok {
			json.Unmarshal([]byte(str.(string)), &all)
		}
		for _, t := range []string{"txt", "pic", "lin", "men"} {
			str, ok = settings[t+"Select"]
			var txtSelect []string
			if ok {
				json.Unmarshal([]byte(str.(string)), &txtSelect)
			}
			str, ok = settings[t+"Custom"]
			var txtCustom [][]string
			if ok {
				json.Unmarshal([]byte(str.(string)), &txtCustom)
			}
			for _, s := range txtSelect {
				for _, menu := range all {
					if menu.C == s {
						menus = append(menus, menu)
					}
				}
				for _, cs := range txtCustom {
					if cs[0] == s {
						nm := Menu{s, "Custom", strings.ToUpper(t), cs[1], "all", 0}
						menus = append(menus, nm)
					}
				}
			}
		}
	}
	iter.Release()
	err := iter.Error()
	if err != nil {
		return err
	}
	menuMap := make(map[string]Menu)
	countMap := make(map[string]map[string]int)
	for _, m := range menus {
		menu, ok := menuMap[m.U]
		if ok {
			menu.V = menu.V + 1
			menuMap[m.U] = menu
			cm, cok := countMap[m.U][m.C]
			if cok {
				countMap[m.U][m.C] = cm + 1
			} else {
				countMap[m.U][m.C] = 1
			}
		} else {
			m.V = 1
			menuMap[m.U] = m
			countMap[m.U] = make(map[string]int)
			countMap[m.U][m.C] = 1
		}
	}
	menus = []Menu{}
	for _, m := range menuMap {
		menus = append(menus, m)
	}
	sort.Sort(MenuList(menus))
	l := len(menus)
	if len(menus) > 100 {
		l = 100
	}
	menus = menus[:l] // top 100
	for i, m := range menus {
		c := 0
		for k, v := range countMap[m.U] {
			if v > c {
				c = v
				menus[i].C = k
			}
		}
		log.Println(c)
		log.Println(menus[i].C)
	}
	MENUS = menus
	return nil
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
func (cache *Cache) Remove(key string) error {
	return cache.db.Delete([]byte(key), nil)
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
func NewCache(path string) *Cache {
	db, _ := leveldb.OpenFile(path, nil)
	ldb := Cache{
		db: db,
	}
	return &ldb
}

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

func init() {
	c := cron.New()
	//c.AddFunc("5 0 0 * * ?", func() {
	c.AddFunc("5 * * * * ?", func() {
		log.Println("定时统计")
		CACHE.All()
	})
	c.Start()
}
func main() {
	log.Printf("CM Start")
	CACHE = NewCache("cache")
	defer CACHE.Close()
	CACHE.All()
	g := gin.Default()
	g.POST("/cm/settings", postSettings)
	g.GET("/cm/settings", getSettings)
	g.GET("/cm/menus", func(c *gin.Context) {
		c.JSON(http.StatusOK, MENUS)
	})
	g.NoRoute(func(c *gin.Context) {
		c.String(http.StatusNotFound, "404")
	})
	g.Run(":8011")
}
