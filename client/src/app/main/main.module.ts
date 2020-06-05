import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { MainRoutingModule } from './main-routing.module';

import { HomeComponent } from './home/home.component';
import { SobreComponent } from './sobre/sobre.component';

@NgModule({
  declarations: [
    HomeComponent,
    SobreComponent
  ],
  imports: [
    CommonModule,
    MainRoutingModule
  ]
})
export class MainModule { }