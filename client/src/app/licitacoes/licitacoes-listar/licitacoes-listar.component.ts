import { Component, OnInit } from '@angular/core';
import { LicitacaoService } from 'src/app/shared/services/licitacao.service';

@Component({
  selector: 'app-licitacoes-listar',
  templateUrl: './licitacoes-listar.component.html',
  styleUrls: ['./licitacoes-listar.component.scss']
})
export class LicitacoesListarComponent implements OnInit {

  licitacoes = [
    // { nu_licitacao: "10101010", vl_licitacao: "100000", de_Obs: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vehicula nulla a sollicitudin gravida. Vivamus et ultricies sem. Praesent ut molestie neque. Sed porttitor, massa vel scelerisque molestie, nibh tortor tincidunt nisl, ac aliquet massa nibh et lorem. Cras a purus arcu. " },
    // { nu_licitacao: "10101010", vl_licitacao: "100000", de_Obs: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vehicula nulla a sollicitudin gravida. Vivamus et ultricies sem. Praesent ut molestie neque. Sed porttitor, massa vel scelerisque molestie, nibh tortor tincidunt nisl, ac aliquet massa nibh et lorem. Cras a purus arcu. " },
    // { nu_licitacao: "10101010", vl_licitacao: "100000", de_Obs: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vehicula nulla a sollicitudin gravida. Vivamus et ultricies sem. Praesent ut molestie neque. Sed porttitor, massa vel scelerisque molestie, nibh tortor tincidunt nisl, ac aliquet massa nibh et lorem. Cras a purus arcu. " },
    // { nu_licitacao: "10101010", vl_licitacao: "100000", de_Obs: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vehicula nulla a sollicitudin gravida. Vivamus et ultricies sem. Praesent ut molestie neque. Sed porttitor, massa vel scelerisque molestie, nibh tortor tincidunt nisl, ac aliquet massa nibh et lorem. Cras a purus arcu. " },
    // { nu_licitacao: "10101010", vl_licitacao: "100000", de_Obs: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum vehicula nulla a sollicitudin gravida. Vivamus et ultricies sem. Praesent ut molestie neque. Sed porttitor, massa vel scelerisque molestie, nibh tortor tincidunt nisl, ac aliquet massa nibh et lorem. Cras a purus arcu. " }
  ];

  constructor(private licitacoesService: LicitacaoService) { }

  ngOnInit(): void {
    this.licitacoesService.getLicitacoes()
    .subscribe(licitacoes => {
      this.licitacoes = licitacoes;
    });
  }

}
