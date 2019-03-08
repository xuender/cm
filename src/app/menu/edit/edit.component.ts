import { Component, OnInit } from '@angular/core';
import { ModalController, ActionSheetController } from '@ionic/angular';
import { now, includes } from 'lodash'
import { Menu } from 'src/app/api/menu';
import { TranslateService } from '@ngx-translate/core';
import { TypeService } from 'src/app/api/type.service';

@Component({
  selector: 'cm-edit',
  templateUrl: './edit.component.html',
  styleUrls: ['./edit.component.scss'],
})
export class EditComponent implements OnInit {
  title = 'Create'
  menu: Menu = {
    n: '',
    c: `${now()}`,
    m: 'page',
    t: ['Custom'],
    u: '',
    l: 'all',
    s: true,
  }
  data: any
  constructor(
    private modal: ModalController,
    private translate: TranslateService,
    private actionSheet: ActionSheetController,
    public typeService: TypeService,
  ) { }
  cancel() {
    this.modal.dismiss()
  }
  get isURL() {
    return includes(this.menu.u, '/')
  }
  async save() {
    const name = await this.translate.get(this.menu.c).toPromise()
    if (name == this.menu.n) {
      this.menu.n = ''
    }
    Object.assign(this.data, this.menu)
    this.modal.dismiss(this.menu, this.title)
  }

  ngOnInit() {
    if (this.data) {
      this.title = 'Edit'
      this.menu = Object.assign({}, this.data)
      if (!this.menu.n) {
        this.translate.get(this.menu.c)
          .subscribe(n => this.menu.n = n)
      }
    } else {
      this.data = {}
    }
  }

  async remove() {
    const del = await this.translate.get('Delete').toPromise()
    const can = await this.translate.get('Cancel').toPromise()
    const pro = await this.translate.get('Prompt').toPromise()
    const actionSheet = await this.actionSheet.create({
      header: pro,
      buttons: [{
        text: del,
        role: 'destructive',
        icon: 'trash',
        handler: () => {
          this.modal.dismiss(this.menu, 'Remove')
        }
      }, {
        text: can,
        icon: 'close',
        role: 'cancel',
      }]
    });
    await actionSheet.present();
  }
}
