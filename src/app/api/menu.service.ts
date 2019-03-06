import { Injectable } from '@angular/core';
import { some } from 'lodash'

import { Menu } from './menu';
import { StorageService } from './storage.service';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  menus: Menu[]
  constructor(
    private storage: StorageService,
    private http: HttpClient,
    private translate: TranslateService,
  ) {
    this.menus = storage.getItem([], 'menus')
    if (this.menus.length == 0) {
      this.http.get<Menu[]>('/assets/init.json')
        .subscribe(menus => {
          this.menus = menus
          this.save()
          this.updateName()
        })
    } else {
      this.updateName()
    }
  }
  updateName() {
    for (const m of this.menus) {
      this.translate.get(m.c)
        .subscribe(n => m.n = n)
    }
  }
  hasMenu(code: string) {
    return code && some(this.menus, { c: code })
  }
  hasType(type: string) {
    return type && some(this.menus, { t: type })
  }
  create(name: string, url: string, menu = 'selection') {
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
    this.save()
    return true
  }
  save() {
    this.storage.setItem(this.menus, 'menus')
  }
}
