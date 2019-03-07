import { Component } from '@angular/core';
import { MenuService } from '../api/menu.service';
@Component({
  selector: 'cm-menu',
  templateUrl: 'menu.page.html',
  styleUrls: ['menu.page.scss']
})
export class MenuPage {
  constructor(public menuService: MenuService) { }
}
