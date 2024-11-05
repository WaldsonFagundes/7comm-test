# flutter_dev_test

**flutter_dev_test** é um aplicativo Flutter desenvolvido para testes, com foco em autenticação segura com TOTP. O app utiliza Clean Architecture e BLoC para garantir modularidade e facilidade de manutenção.


<p align="center">
  <img src="assets/appimg1.png" width="200" alt="Demonstração do App">
   <img src="assets/appimg2.png" width="200" alt="Demonstração do App">
</p>

## Funcionalidades

- Login seguro com TOTP

## Tecnologias Utilizadas

O projeto utiliza as seguintes bibliotecas e tecnologias:

- **Flutter**: Framework principal
- **flutter_bloc** e **bloc**: Gerenciamento de estado com BLoC
- **dartz**: Programação funcional, uso de tipos
- **otp**: Geração de códigos TOTP
- **go_router**: Navegação no app
- **get_it**: Injeção de dependência

### Principais Conceitos

- **Clean Architecture**: Organização modular em camadas de dados, domínio e apresentação.
- **BLoC**: Gerenciamento de estado, facilitando fluxos de dados reativos e separados da UI.
- **Programação Funcional**: Uso de `dartz` com `Either` para um tratamento de falhas mais robusto e explícito.

## Testes

O projeto inclui testes unitários para casos de uso, repositórios e blocs, garantindo qualidade e robustez na lógica de negócio. 
