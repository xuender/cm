import { Injectable } from '@angular/core';
import { some } from 'lodash'
import { Menu } from './menu';
import { StorageService } from './storage.service';

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  menus: Menu[]
  constructor(private storage: StorageService) {
    this.menus = storage.getItem([], 'menus')
  }
  hasMenu(code: string) {
    return code && some(this.menus, { c: code })
  }
  hasType(type: string) {
    return type && some(this.menus, { t: type })
  }
  create(name: string, url: string, menu = 'MEN') {
    if (this.hasMenu(name)) {
      return false
    }
    const m: Menu = {
      t: 'Custom',
      m: menu,
      n: name,
      c: name,
      l: 'all',
      u: url,
    }
    this.menus.push(m)
    return true
  }
}
