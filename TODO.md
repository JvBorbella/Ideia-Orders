# TODO

- [ ] Implementar no `CustomerSession` (customer_session.dart) proteção de navegação:
  - [ ] Agrupar TextEditingControllers em lista
  - [ ] Criar flag bool para quando `NewCustomer.adjustOrder` for chamado
  - [ ] Detectar se qualquer controller possui valor
  - [ ] Interceptar pop/rota com `PopScope` e, se não salvou, exibir `showDialog`
  - [ ] No action do diálogo, chamar `saveOrder()`
  - [ ] Substituir chamadas diretas de `NewCustomer.adjustOrder` pela versão que marca a flag
- [ ] Rodar `flutter analyze`
- [ ] Rodar testes manuais de UI (back/voltar, salvar, finalizar e aplicar desconto)

