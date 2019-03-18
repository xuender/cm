import { TestBed } from '@angular/core/testing';

import { ContextService } from './context.service';

describe('ContextService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ContextService = TestBed.get(ContextService);
    expect(service).toBeTruthy();
  });
});
