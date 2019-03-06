import { Injectable } from '@angular/core';
import { isString } from 'lodash'


@Injectable({
  providedIn: 'root'
})
export class StorageService {
  private cache = new Map<string, any>()

  get language() {
    return this.getCache('en', 'language', 'locale')
  }

  set language(value: string) {
    this.setCache(value, 'language', 'locale')
  }

  get qrSize() {
    return this.getCache(250, 'qrSize', 'qr_size')
  }

  set qrSize(value: number) {
    this.setCache(value, 'qrSize', 'qr_size')
  }

  private getCache(def: any, ...keys: string[]) {
    if (keys.length < 1) {
      return def
    }
    if (this.cache.has(keys[0])) {
      return this.cache.get(keys[0])
    }
    const v = this.getItem(def, ...keys)
    this.cache.set(keys[0], v)
    return v
  }

  private setCache(value: any, ...keys: string[]) {
    if (keys.length > 0) {
      this.cache.set(keys[0], value)
      this.setItem(value, ...keys)
    }
  }

  getItem(def: any, ...keys: string[]) {
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

  setItem(value: any, ...keys: string[]) {
    if (keys.length < 1) {
      return
    }
    for (const key of keys) {
      window.localStorage.removeItem(key)
    }
    window.localStorage.setItem(keys[0], JSON.stringify(value))
  }
}
