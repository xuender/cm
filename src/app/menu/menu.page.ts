import { Component } from '@angular/core';
import { includes, some, chain, forEach } from 'lodash';

import { MenuService } from '../api/menu.service';
import { Menu } from '../api/menu';
import { Context } from '../api/context';
import { ContextService } from '../api/context.service';
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
    public contextService: ContextService,
  ) { }

  ngOnInit(): void { }

  preview(c: string) {
    return chain<Menu[]>(this.menuService.menus)
      .filter((menu: Menu) => includes(menu.contexts, c) && menu.select)
      .sortBy(['order', 'name'])
      .value()
  }

  reorderHandler(event, m: string) {
    forEach(event.detail.complete(this.preview(m)), (m: Menu, order: number) => {
      m.order = order
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
      .filter(m => this.contextService.isOpen(m))
      .filter(m => this.tagSet.size == 0 || !m.tags || some(m.tags, t => this.tagSet.has(t)))
      .filter(m => !this.search
        || includes(m.name, this.search)
        || includes(m.id, this.search)
        || includes(m.url, this.search)
        || includes(this.menuService.idMap.get(m.id), this.search)
      )
      .sortBy(m => this.contextService.sort(m))
      .value()
  }

  toggle(type: Context) {
    type.open = !type.open
    const tags = this.menuService.contextTags
    for (const t of this.tagSet) {
      if (!tags.has(t)) {
        this.tagSet.delete(t)
      }
    }
  }
}
