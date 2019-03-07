import { Injectable } from '@angular/core';
import { some, pullAllBy } from 'lodash'
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { ModalController, ToastController } from '@ionic/angular';

import { Menu } from './menu';
import { StorageService } from './storage.service';
import { EditComponent } from '../menu/edit/edit.component';

@Injectable({
  providedIn: 'root'
})
export class MenuService {
  menus: Menu[]
  constructor(
    private storage: StorageService,
    private http: HttpClient,
    private translate: TranslateService,
    private modal: ModalController,
    private toast: ToastController,
  ) {
    this.menus = storage.getItem([], 'menus')
    if (this.menus.length == 0) {
      this.http.get<Menu[]>('/assets/init.json')
        .subscribe(menus => {
          this.menus = menus
          this.save()
        })
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
