import { chain, find } from 'lodash'

import { getItem, removeAll } from './app/api/utils';
import { Menu } from './app/api/menu';

class CmBackground {
  menus: Menu[] = []
  private clipboardInput = document.createElement('input')
  private replaceMap = new Map([
    [/%s|%S/g, encodeURIComponent],
    [/%g|%G/g, encodeURIComponent],
    [/%t|%T/g, encodeURIComponent],
  ])
  constructor() {
    console.log('start')
    this.clipboardInput.type = 'text'
    document.body.appendChild(this.clipboardInput)
    this.reset()
      .then(() => chrome.runtime.onStartup.addListener(this.reset))
  }

  async reset() {
    console.debug('reset')
    await removeAll()
    this.menus = chain<Menu[]>(getItem([], 'menus'))
      .filter(m => m.select)
      .sortBy(['order', 'name'])
      .value()
    for (const m of this.menus) {
      await this.createMenu(m)
    }
  }

  private readClipboard() {
    this.clipboardInput.select()
    document.execCommand('paste')
    return this.clipboardInput.value
  }
  private createMenu(menu: Menu) {
    let title = menu.title ? menu.title : (menu.name ? menu.name : menu.id)
    if (menu.back) {
      title = `₪ ${title}`
    }
    if (menu.incognito) {
      title = `☢ ${title}`
    }
    console.debug('createMenu:', title)
    const createProperties: chrome.contextMenus.CreateProperties = {
      id: menu.id,
      title: title,
      contexts: menu.contexts,
    }
    if (menu.type) {
      createProperties.type = menu.type
    }
    if ('separator' != menu.type) {
      createProperties.onclick = (info: chrome.contextMenus.OnClickData, tab: chrome.tabs.Tab) =>
        this.onClicked(info, tab)
    }
    return new Promise(resolve => chrome.contextMenus.create(createProperties, resolve))
  }

  async onClicked(info: chrome.contextMenus.OnClickData, tab: chrome.tabs.Tab) {
    console.debug('click', info, tab)
    const menu = find<Menu>(this.menus, { id: info.menuItemId })
    console.dir(menu)
    const isPage = /\/|.htm/.test(menu.url)
    console.debug(isPage)
    const value = chain([info.selectionText, info.srcUrl, info.linkUrl, info.frameUrl, info.pageUrl])
      .compact()
      .head()
      .value()
    console.debug('value', value)
    if (isPage) {
      let url = menu.url
      if (/%u|%U/g.test(url)) {
        url = url.replace(/%u|%U/g, tab.url.split('/')[2])
      }
      if (/%l|%L/g.test(url)) {
        url = url.replace(/%l|%L/g, encodeURIComponent(tab.title))
      }
      if (/%p|%P/g.test(url)) {
        url = url.replace(/%p|%P/g, encodeURIComponent(this.readClipboard()))
      }
      for (const k of this.replaceMap) {
        if (k[0].test(url)) {
          console.debug('k[0]', k[0], url)
          url = url.replace(k[0], k[1](value))
        }
      }
      console.debug('url', url)
      if (menu.incognito) {
        // TODO find window
        await this.createWindow({ url: url, incognito: true, })
        return
      }
      // TODO newWindow
      // TODO find window
      const createProperties: chrome.tabs.CreateProperties = {
        url: url,
        selected: !menu.back,
        index: tab.index + 1,
      }
      await this.createTab(createProperties)
    }
  }

  private createTab(createProperties: chrome.tabs.CreateProperties) {
    return new Promise(resolve => chrome.tabs.create(createProperties, resolve))
  }

  private createWindow(createData: chrome.windows.CreateData) {
    return new Promise(resolve => chrome.windows.create(createData, resolve))
  }
}

window['cm'] = new CmBackground()
