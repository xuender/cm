import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { StorageService } from '../api/storage.service';

@Component({
  selector: 'cm-tabs',
  templateUrl: 'tabs.page.html',
  styleUrls: ['tabs.page.scss']
})
export class TabsPage {
  constructor(
    private translate: TranslateService,
    private storage: StorageService,
  ) {
    translate.setDefaultLang(storage.language);
  }
}
