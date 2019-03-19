import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ModalController, ToastController } from '@ionic/angular';

import { TranslateService } from '@ngx-translate/core';
import { some, pullAllBy, forEach, chain, map, isString } from 'lodash'

import { Menu } from './menu';
import { StorageService } from './storage.service';
import { EditComponent } from '../menu/edit/edit.component';
import { ContextService } from './context.service';
import { getBackgroundPage } from './utils';

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  menus: Menu[]
  codeMap = new Map<string, string>()
  private keyMap = new Map<string, string>([
    ['t', 'tags'],
    ['n', 'name'],
    ['e', 'title'],
    ['b', 'back'],
    ['c', 'code'],
    ['i', 'incognito'],
    ['m', 'contexts'],
    ['l', 'language'],
    ['u', 'url'],
    ['v', 'value'],
    ['s', 'select'],
    ['o', 'order'],
  ])
  constructor(
    private storage: StorageService,
    private http: HttpClient,
    private translate: TranslateService,
    private modal: ModalController,
    private toast: ToastController,
    private contextService: ContextService,
  ) {
    this.menus = this.oldMenu(storage.getItem([], 'menus'))
    if (this.menus.length == 0) {
      this.http.get<Menu[]>('/assets/init.json')
        .subscribe(menus => {
          this.menus = this.oldMenu(menus)
          this.init()
          this.save()
        })
    } else {
      this.init()
    }
  }

  private oldMenu(old: any[]) {
    return map(old, o => {
      const ret = {} as any
      for (const k of this.keyMap) {
        if (k[0] in o) {
          ret[k[1]] = o[k[0]]
        }
        if (k[1] in o) {
          ret[k[1]] = o[k[1]]
        }
      }
      if (isString(ret.contexts)) {
        ret.contexts = [ret.contexts]
      }
      return ret as Menu
    })
  }

  get contextTags() {
    const tags = new Set<String>()
    chain<Menu[]>(this.menus)
      .filter(m => this.contextService.isOpen(m))
      .forEach(m => forEach(m.tags, t => tags.add(t)))
      .value()
    // console.log('tags', tags)
    return tags
  }

  private init() {
    forEach(this.menus, m => forEach(m.tags, t => this.contextService.tags.add(t)))
    this.language()
  }

  async language() {
    this.codeMap.clear()
    for (const m of this.menus) {
      this.codeMap.set(m.code, await this.translate.get(m.code).toPromise())
    }
  }

  hasMenu(code: string) {
    return code && some(this.menus, { code: code })
  }

  hasType(type: string) {
    return type && some(this.menus, { t: type })
  }

  async edit(menu = undefined) {
    const modal = await this.modal.create({
      component: EditComponent,
      componentProps: {
        data: menu
      }
    });
    await modal.present();
    const data = await modal.onDidDismiss()
    console.log('data', data)
    if (data.role) {
      switch (data.role) {
        case 'Create':
          this.menus.push(data.data)
          await this.message(await this.translate.get('create menu ok', data.data).toPromise())
          break
        case 'Remove':
          pullAllBy(this.menus, [{ c: data.data.code }], 'code')
          await this.message(await this.translate.get('delete menu ok', data.data).toPromise())
          break
        case 'backdrop':
          return
      }
      await this.save()
    }
  }

  async message(msg: string) {
    const toast = await this.toast.create({
      message: msg,
      duration: 2000,
      position: 'top',
      color: 'dark',
    });
    return toast.present();
  }
  /*
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
  */
  async save() {
    for (const m of this.menus) {
      if (m.select) {
        m.title = m.name ? m.name : await this.translate.get(m.code).toPromise()
      } else {
        delete m.title
        delete m.select
      }
    }
    this.storage.setItem(this.menus, 'menus')
    try {
      const backgroundPage = await getBackgroundPage()
      const cm = backgroundPage['cm']
      if (cm) {
        cm.reset()
      }
      // debugger
    } catch (e) {
      console.error('save: ', e)
    }
  }
}
