package main

import (
	"bytes"
	"encoding/gob"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/contrib/gzip"
	"github.com/gin-gonic/gin"
	"github.com/penlook/daemon"
	"github.com/robfig/cron"
	"github.com/syndtr/goleveldb/leveldb"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"sort"
	"strings"
	"time"
)

var CACHE *Cache
var PATH_SEPARATOR = fmt.Sprintf("%c", os.PathSeparator)
var PATH = GetDir(os.Args[0]) + PATH_SEPARATOR

type Cache struct {
	db    *leveldb.DB
	menus []Menu
}

func (cache *Cache) findMenus() (menus []Menu) {
	iter := cache.db.NewIterator(nil, nil)
	for iter.Next() {
		//key := iter.Key()
		//value := iter.Value()
		var settings map[string]interface{}
		dec := gob.NewDecoder(bytes.NewBuffer(iter.Value()))
		dec.Decode(&settings)
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
			// TODO 根据mcGroup增加选择ID
			//str, ok = settings[t[0:1]+"cGroup"]
			//var mcGroup [][]interface{}
			//if ok {
			//	json.Unmarshal([]byte(str.(string)), &mcGroup)
			//	log.Println(mcGroup)
			//}
			str, ok = settings[t+"Custom"]
			var txtCustom [][]string
			if ok {
				json.Unmarshal([]byte(str.(string)), &txtCustom)
			}
			//var ids []string
			//for _, s := range txtSelect {
			//	for _, mc := range mcGroup {
			//		if mc[0] == s {
			//			log.Println(reflect.TypeOf(mc[1]))
			//			ids = append(ids, mc[1].([]string)...)
			//			//txtSelect = append(txtSelect, mc[1].([]string)...)
			//		}
			//	}
			//}
			//log.Println(ids)
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
		return nil
	}
	return
}
func readMenus() ([]Menu, error) {
	bytes, err := ioutil.ReadFile(PATH + "menus.json")
	if err != nil {
		log.Println("ReadFile: ", err.Error())
		return nil, err
	}
	var menus []Menu
	if err := json.Unmarshal(bytes, &menus); err != nil {
		log.Println("Unmarshal: ", err.Error())
		return nil, err
	}
	return menus, nil
}
func (cache *Cache) All() error {
	menus := cache.findMenus()
	jsonMenus, je := readMenus()
	if je == nil {
		menus = append(menus, jsonMenus...)
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
			//m.V = 1
			menuMap[m.U] = m
			countMap[m.U] = make(map[string]int)
			countMap[m.U][m.C] = 1
		}
	}
	menus = []Menu{}
	for _, mode := range []string{"MEN", "TXT", "PIC", "LIN"} {
		ms := []Menu{}
		for _, m := range menuMap {
			if m.M == mode {
				ms = append(ms, m)
			}
		}
		sort.Sort(MenuList(ms))
		l := len(ms)
		if len(ms) > 100 {
			l = 100
		}
		menus = append(menus, ms[:l]...) // top 100
	}
	for i, m := range menus {
		c := 0
		for k, v := range countMap[m.U] {
			if v > c {
				c = v
				menus[i].C = k
			}
		}
	}
	cache.menus = menus
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
	//c.AddFunc("5 * * * * ?", func() {
	c.AddFunc("5 0 0 * * ?", func() {
		start := time.Now()
		CACHE.All()
		end := time.Now()
		latency := end.Sub(start)
		log.Printf("cron: %13v\n", latency)
	})
	c.Start()
}

type Service struct {
	daemon.Daemon
}

func (service *Service) Manage(name string, gomain func()) (string, error) {
	usage := "Usage: " + name + " install | remove | start | stop | status"
	if len(os.Args) > 1 {
		command := os.Args[1]
		switch command {
		case "install":
			return service.Install()
		case "remove":
			return service.Remove()
		case "start":
			return service.Start()
		case "stop":
			return service.Stop()
		case "status":
			return service.Status()
		default:
			return usage, nil
		}
	}
	gomain()
	return usage, nil
}

func GetDir(path string) string {
	ds := strings.Split(path, PATH_SEPARATOR)
	if len(ds) == 0 {
		return ""
	}
	return strings.Join(ds[:len(ds)-1], PATH_SEPARATOR)
}
func ServiceRun(name, description string, gomain func()) {
	srv, err := daemon.New(name, description)
	if err != nil {
		log.Println("Error: ", err)
		os.Exit(1)
	}
	service := &Service{srv}
	status, err := service.Manage(name, gomain)
	if err != nil {
		log.Println(status, "\nError: ", err)
		os.Exit(1)
	}
	log.Println(status)
}
func run() {
	log.Printf("CM Server Start")
	CACHE = NewCache(PATH + "cache")
	defer CACHE.Close()
	CACHE.All()
	gin.SetMode(gin.ReleaseMode)
	g := gin.Default()
	g.Use(gzip.Gzip(gzip.DefaultCompression))
	g.POST("/cm/settings", postSettings)
	g.GET("/cm/settings", getSettings)
	g.GET("/cm/menus", func(c *gin.Context) {
		c.JSON(http.StatusOK, CACHE.menus)
	})
	g.NoRoute(func(c *gin.Context) {
		c.String(http.StatusNotFound, "404")
	})
	g.Run(":8011")
}
func main() {
	ServiceRun("cmserver", "CM server", run)
}
