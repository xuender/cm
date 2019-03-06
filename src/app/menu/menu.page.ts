import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { filter, some, chain, forEach } from 'lodash'

import { MenuService } from '../api/menu.service';
import { Menu } from '../api/menu';

@Component({
  selector: 'cm-menu',
  templateUrl: 'menu.page.html',
  styleUrls: ['menu.page.scss']
})
export class MenuPage implements OnInit {
  name = ''
  url = ''
  id = ''
  types = ['all', 'chrome', 'sns', 'utils', 'fy', 'movie', 'pic', 'shop', 'book', 'Custom']
  constructor(
    public menuService: MenuService,
    private router: ActivatedRoute,
  ) { }
  ngOnInit(): void {
    this.router.paramMap.pipe().subscribe((params: ParamMap) => {
      this.id = params.get('id')
    })
  }
  hasType(type: string) {
    return type && some(this.menuService.menus, { t: type, m: this.id })
  }
  group(type: string) {
    return filter(this.menuService.menus, m => m.m == this.id && m.t == type)
  }
  select() {
    return chain<Menu>(this.menuService.menus)
      .filter((m: Menu) => m.m == this.id && m.s)
      .sortBy(['o', 'n'])
      .value()
  }
  create() {
    if (this.menuService.create(this.name, this.url, this.id)) {
      this.name = ''
      this.url = ''
    }
  }
  reorderHandler(event) {
    forEach(event.detail.complete(this.select()), (m: Menu, o: number) => {
      m.o = o
      return true
    })
    this.menuService.save()
  }
}
