class CmBackground {
  constructor() {
    chrome.runtime.onStartup.addListener(this.reset)
    chrome.contextMenus.onClicked.addListener(this.onClicked)
    this.reset()
  }
  onClicked(info: chrome.contextMenus.OnClickData, tab: chrome.tabs.Tab) {
    // id = info.menuItemId[1..]
    // value = getValue(info, tab, type)
    // openTab(id, type, value, tab)
    console.debug('click', info, tab)
  }
  async reset() {
    console.debug('reset')
    await this.removeAll()
    await this.createMenu('测试', 'xxx', 'page')
  }
  removeAll() {
    console.debug('removeAll')
    return new Promise(resolve => {
      chrome.contextMenus.removeAll(resolve)
    })
  }
  createMenu(title: string, id: string, ...contexts: string[]) {
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
new CmBackground()
