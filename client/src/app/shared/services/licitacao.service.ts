import { Licitacao } from './../models/licitacao.model';
import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';

import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class LicitacaoService {

  private url = environment.apiUrl + 'licitacoes';

  constructor(private http: HttpClient) { }


  // Lista todas as licitações
  getLicitacoes(): Observable<Licitacao[]> {
    return this.http.get<Licitacao[]>(`${this.url}`);
  }
}
