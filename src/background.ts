import { chain, filter, find, includes } from 'lodash'

import { getItem, removeAll } from './app/api/utils';
import { Menu } from './app/api/menu';

class CmBackground {
  menus: Menu[] = []
  contexts = ['page', 'selection', 'image', 'link']
  constructor() {
    chrome.runtime.onStartup.addListener(this.reset)
    chrome.contextMenus.onClicked.addListener((info, tab) => this.open(info, tab))
    this.reset()
  }

  async open(info: chrome.contextMenus.OnClickData, tab: chrome.tabs.Tab) {
    console.debug('click', info, tab)
    const menu = find<Menu>(this.menus, { code: info.menuItemId })
    console.dir(menu)
    const isPage = /\/|.htm/.test(menu.url)
    console.debug(isPage)
    const back = false
    let url = tab.url
    let ni = tab.index + 1
    url = menu.url
    chrome.tabs.create({ url: url, selected: !back, index: ni })
  }

  async reset() {
    console.debug('reset')
    await removeAll()
    this.menus = chain<Menu[]>(getItem([], 'menus'))
      .filter(m => m.select)
      .sortBy(['order', 'name'])
      .value()
    for (const c of this.contexts) {
      for (const m of filter<Menu>(this.menus, m => includes(m.contexts, c))) {
        let title = m.title ? m.title : (m.name ? m.name : m.code)
        await this.createMenu(title, m.code, c)
      }
    }
  }

  private createMenu(title: string, id: string, ...contexts: string[]) {
    console.debug('createMenu:', title)
    return new Promise(resolve => {
      chrome.contextMenus.create({
        contexts: contexts,
        title: title,
        id: id,
      }, resolve)
    })
  }
}

window['cm'] = new CmBackground()
