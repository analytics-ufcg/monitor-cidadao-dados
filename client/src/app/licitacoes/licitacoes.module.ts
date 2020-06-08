import { LicitacoesListarComponent } from './licitacoes-listar/licitacoes-listar.component';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';



@NgModule({
  declarations: [LicitacoesListarComponent],
  imports: [
    CommonModule
  ], exports: [
    LicitacoesListarComponent
  ]
})
export class LicitacoesModule { }
