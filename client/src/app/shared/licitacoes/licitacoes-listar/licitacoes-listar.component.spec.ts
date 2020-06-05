import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LicitacoesListarComponent } from './licitacoes-listar.component';

describe('LicitacoesListarComponent', () => {
  let component: LicitacoesListarComponent;
  let fixture: ComponentFixture<LicitacoesListarComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LicitacoesListarComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LicitacoesListarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
