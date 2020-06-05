import { TestBed } from '@angular/core/testing';

import { LicitacaoService } from './licitacao.service';

describe('LicitacaoService', () => {
  let service: LicitacaoService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LicitacaoService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
