import { Injectable } from '@angular/core';
import { isString } from 'lodash'


@Injectable({
  providedIn: 'root'
})
export class StorageService {
  private cache = new Map()

  get language() {
    return this.getVariable('language', 'en', 'language', 'locale')
  }

  set language(value: string) {
    this.setVariable('language', value, 'language', 'locale')
  }

  private getVariable(variable: string, def: string, ...keys: string[]) {
    if (this.cache.has(variable)) {
      return this.cache.get(variable)
    }
    const v = this.getItem(def, ...keys)
    this.cache.set(variable, v)
    return v
  }

  private setVariable(variable: string, value: string, ...keys: string[]) {
    this.cache.set(variable, value)
    this.setItem(value, ...keys)
  }

  getItem(def: string, ...keys: string[]) {
    for (const key of keys) {
      const t = window.localStorage.getItem(key)
      if (isString(t)) {
        return t
      }
    }
    return def
  }

  setItem(value: string, ...keys: string[]) {
    if (keys.length < 1) {
      return
    }
    for (const key of keys) {
      window.localStorage.removeItem(key)
    }
    window.localStorage.setItem(keys[0], value)
  }
}
