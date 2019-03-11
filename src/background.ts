import { chain, filter, find, includes } from 'lodash'
import { getItem } from './app/api/utils';
import { Menu } from './app/api/menu';

class CmBackground {
  menus: Menu[] = []
  types = ['page', 'selection', 'image', 'link']
  constructor() {
    chrome.runtime.onStartup.addListener(this.reset)
    chrome.contextMenus.onClicked.addListener((info, tab) => this.open(info, tab))
    this.reset()
  }
  async open(info: chrome.contextMenus.OnClickData, tab: chrome.tabs.Tab) {
    console.debug('click', info, tab)
    const menu = find<Menu>(this.menus, { c: info.menuItemId })
    console.dir(menu)
    const isPage = /\/|.htm/.test(menu.u)
    console.log(isPage)
    const back = false
    let url = tab.url
    let ni = tab.index + 1
    switch (menu.m) {
      case 'page':
        if (isPage) {
          url = menu.u
        }
        break
    }
    chrome.tabs.create({ url: url, selected: !back, index: ni })
  }
  async reset() {
    console.debug('reset')
    await this.removeAll()
    this.menus = chain<Menu[]>(getItem([], 'menus'))
      .filter(m => m.s)
      .sortBy(['o', 'n'])
      .value()
    for (const type of this.types) {
      for (const m of filter<Menu>(this.menus, m => m.m == type)) {
        let title = m.e ? m.e : (m.n ? m.n : m.c)
        await this.createMenu(title, m.c, type)
      }
    }
  }
  removeAll() {
    console.debug('removeAll')
    return new Promise(resolve => {
      chrome.contextMenus.removeAll(resolve)
    })
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
const cm = new CmBackground()
