import { Component } from '@angular/core';
import { includes, some, findIndex, chain, forEach } from 'lodash';

import { MenuService } from '../api/menu.service';
import { Menu } from '../api/menu';
import { Type } from '../api/type';
import { TypeService } from '../api/type.service';
import { sleep } from '../api/utils';
@Component({
  selector: 'cm-menu',
  templateUrl: 'menu.page.html',
  styleUrls: ['menu.page.scss']
})
export class MenuPage {
  tagSet = new Set<String>()
  search = ''
  constructor(
    public menuService: MenuService,
    public typeService: TypeService,
  ) { }

  ngOnInit(): void {
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
  async select(event) {
    event.stopPropagation()
    await sleep(100)
    await this.menuService.save()
  }
  get menus() {
    return chain<Menu[]>(this.menuService.menus)
      .filter(m => this.typeService.inTypes(m))
      .filter(m => this.tagSet.size == 0 || !m.t || some(m.t, t => this.tagSet.has(t)))
      .filter(m => !this.search
        || includes(m.n, this.search) // name
        || includes(m.c, this.search) // code
        || includes(m.u, this.search) // url
        || includes(this.menuService.codeMap.get(m.c), this.search) // translate
      )
      .sortBy(m => this.typeService.sort(m))
      .value()
  }

  toggle(type: Type) {
    type.open = !type.open
    const tags = this.menuService.typeTags
    for (const t of this.tagSet) {
      if (!tags.has(t)) {
        this.tagSet.delete(t)
      }
    }
  }
}
