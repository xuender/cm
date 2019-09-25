import { isString } from 'lodash';

export function getItem(def: any, ...keys: string[]) {
  for (const key of keys) {
    const value = window.localStorage.getItem(key)
    if (value && isString(value)) {
      try {
        return JSON.parse(value)
      } catch (e) {
        return value
      }
    }
  }
  return def
}

export function setItem(value: any, ...keys: string[]) {
  if (keys.length < 1) {
    return
  }
  for (const key of keys) {
    window.localStorage.removeItem(key)
  }
  window.localStorage.setItem(keys[0], JSON.stringify(value))
}

export function sleep(ms: number) {
  return new Promise(resolve =>
    setTimeout(resolve, ms)
  )
}

export function removeAll() {
  return getChrome('chrome.contextMenus.removeAll')
}

export function getBackgroundPage() {
  return getChrome('chrome.runtime.getBackgroundPage')
}
export function getSelectedTab() {
  return getChrome('chrome.tabs.getSelected')
}

function getChrome(key: string) {
  return new Promise((resolve, reject) => {
    let obj = window as any
    for (const k of key.split('.')) {
      obj = obj[k] as any
      if (!obj) {
        reject(`Missing ${k} by ${key}.`)
        return
      }
    }
    obj(resolve)
  })
}

export function urlEncode(url: string) {

}
