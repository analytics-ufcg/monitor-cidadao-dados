import { Licitacao } from './../../models/licitacao.model';
import { LicitacaoService } from './../../services/licitacao.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'licitacoes-listar',
  templateUrl: './licitacoes-listar.component.html',
  styleUrls: ['./licitacoes-listar.component.scss']
})
export class LicitacoesListarComponent implements OnInit {

  licitacoes;

  constructor(private licitacaoService:LicitacaoService) { }

  ngOnInit(): void {
    this.licitacoes = this.licitacaoService.getLicitacoes().subscribe (test =>{
      console.log (test)
    });
  }

}
