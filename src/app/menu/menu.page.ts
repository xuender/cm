import { Component } from '@angular/core';
import { filter } from 'lodash'
import { MenuService } from '../api/menu.service';
import { Menu } from '../api/menu';

@Component({
  selector: 'cm-menu',
  templateUrl: 'menu.page.html',
  styleUrls: ['menu.page.scss']
})
export class MenuPage {
  name: string = ''
  url: string = ''
  types = ['Chrome', 'Custom']
  constructor(public menuService: MenuService) {
  }
  group(type: string) {
    return filter(this.menuService.menus, m => m.t == type)
  }
  create() {
    if (this.menuService.create(this.name, this.url)) {
      this.name = ''
      this.url = ''
    }
  }
}
