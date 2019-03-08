import { Injectable } from '@angular/core';
import { some, pullAllBy, forEach, chain } from 'lodash'
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { ModalController, ToastController } from '@ionic/angular';

import { Menu } from './menu';
import { StorageService } from './storage.service';
import { EditComponent } from '../menu/edit/edit.component';
import { Type } from './type';
import { TypeService } from './type.service';

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  menus: Menu[]
  codeMap = new Map<string, string>()
  constructor(
    private storage: StorageService,
    private http: HttpClient,
    private translate: TranslateService,
    private modal: ModalController,
    private toast: ToastController,
    private typeService: TypeService,
  ) {
    this.menus = storage.getItem([], 'menus')
    if (this.menus.length == 0) {
      this.http.get<Menu[]>('/assets/init.json')
        .subscribe(menus => {
          this.menus = menus
          this.init()
          this.save()
        })
    } else {
      this.init()
    }
  }
  get typeTags() {
    const tags = new Set<String>()
    chain<Menu[]>(this.menus)
      .filter(m => some<Type>(this.typeService.types, { name: m.m, open: true }))
      .forEach(m => forEach(m.t, t => tags.add(t)))
      .value()
    // console.log('tags', tags)
    return tags
  }
  private init() {
    forEach(this.menus, m => forEach(m.t, t => this.typeService.tags.add(t)))
    this.language()
  }
  async language() {
    this.codeMap.clear()
    for (const m of this.menus) {
      this.codeMap.set(m.c, await this.translate.get(m.c).toPromise())
    }
  }
  hasMenu(code: string) {
    return code && some(this.menus, { c: code })
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
    if (data.role) {
      switch (data.role) {
        case 'Create':
          this.menus.push(data.data)
          await this.message(await this.translate.get('create menu ok', data.data).toPromise())
          break
        case 'Remove':
          pullAllBy(this.menus, [{ c: data.data.c }], 'c')
          await this.message(await this.translate.get('delete menu ok', data.data).toPromise())
          break
      }
      this.save()
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
  save() {
    this.storage.setItem(this.menus, 'menus')
  }
}
