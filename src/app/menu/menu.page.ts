import { Component } from '@angular/core';
import { includes, some, findIndex, chain, forEach, find } from 'lodash';

import { MenuService } from '../api/menu.service';
import { Menu } from '../api/menu';
import { Type } from './type';
import { TranslateService } from '@ngx-translate/core';
@Component({
  selector: 'cm-menu',
  templateUrl: 'menu.page.html',
  styleUrls: ['menu.page.scss']
})
export class MenuPage {
  types: Type[] = [
    { name: 'page', open: true, icon: 'menu' },
    { name: 'selection', open: false, icon: 'crop' },
    { name: 'image', open: false, icon: 'image' },
    { name: 'link', open: false, icon: 'link' },
  ]
  tagSet = new Set<String>()
  search = ''
  constructor(
    public menuService: MenuService,
  ) { }

  icon(type: string) {
    return chain<Type[]>(this.types)
      .filter(t => t.name == type)
      .first()
      .value().icon
  }
  ngOnInit(): void {
    // forEach(this.menuService.menus, m => forEach(m.t, t => this.tags.add(t)))
  }
  get tags() {
    const tags = new Set<String>()
    chain<Menu[]>(this.menuService.menus)
      .filter(m => some<Type>(this.types, { name: m.m, open: true }))
      .forEach(m => forEach(m.t, t => tags.add(t)))
      .value()
    // console.log('tags', tags)
    return tags
  }
  preview(type: string) {
    return chain<Menu[]>(this.menuService.menus)
      .filter((menu: Menu) => menu.m == type && menu.s)
      .sortBy(['o', 'n'])
      .value()
  }
  reorderHandler(event, m: string) {
    forEach(event.detail.complete(this.preview(m)), (m: Menu, o: number) => {
      m.o = o
      return true
    })
    this.menuService.save()
  }
  select(event) {
    event.stopPropagation()
    this.menuService.save()
  }
  get menus() {
    return chain<Menu[]>(this.menuService.menus)
      .filter(m => some<Type>(this.types, { name: m.m, open: true }))
      .filter(m => this.tagSet.size == 0 || !m.t || some(m.t, t => this.tagSet.has(t)))
      .filter(m => !this.search
        || includes(m.n, this.search) // name
        || includes(m.c, this.search) // code
        || includes(m.u, this.search) // url
        || includes(this.menuService.codeMap.get(m.c), this.search) // translate
      )
      .sortBy(m => `${findIndex(this.types, t => t.name == m.m)}${m.n}${m.c}`)
      .value()
  }
}
