import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { chain, includes } from 'lodash';

import { StorageService } from 'src/app/api/storage.service';
import { Menu } from 'src/app/api/menu';
import { getBackgroundPage, getSelectedTab } from 'src/app/api/utils';

@Component({
  selector: 'cm-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  menus: Menu[] = []
  input: string = ''
  constructor(
    private translate: TranslateService,
    private storage: StorageService,
  ) {
    translate.setDefaultLang(storage.language);
    this.input = storage.getItem('', 'selection')
    this.menus = chain<Menu[]>(storage.getItem([], 'menus'))
      .filter((menu: Menu) => menu.select)
      .filter((menu: Menu) => includes(menu.contexts, 'all') || includes(menu.contexts, 'selection'))
      .sortBy(['order', 'name'])
      .value()
  }
  async search(menu: Menu) {
    const backgroupPage = await getBackgroundPage()
    if (backgroupPage) {
      const cm = backgroupPage['cm'] as any
      const tab = await getSelectedTab() as any
      await cm.open(menu, this.input, tab)
    }
  }
  async settings() {
    const m: Menu = {
      id: 'i_title',
      url: 'options.html',
      contexts: ['page'],
    }
    await this.search(m)
  }
}
