import { Injectable } from '@angular/core';
import { setItem, getItem } from './utils';


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
    const v = getItem(def, ...keys)
    this.cache.set(keys[0], v)
    return v
  }

  private setCache(value: any, ...keys: string[]) {
    if (keys.length > 0) {
      this.cache.set(keys[0], value)
      setItem(value, ...keys)
    }
  }
  getItem(def: any, ...keys: string[]) {
    return getItem(def, ...keys)
  }
  setItem(value: any, ...keys: string[]) {
    setItem(value, ...keys)
  }
}
