# 📦 Flutter BuscaCEP

Aplicativo Flutter que permite ao usuário buscar informações de um endereço a partir do CEP utilizando a API pública ViaCEP. Além disso, é possível adicionar, editar e excluir endereços, com campos extras como complemento, número e apartamento.

## 🚀 Funcionalidades

- 🔍 Busca de endereço por CEP
- 📝 Adição de informações extras (complemento, número e apartamento)
- 🧾 Listagem de endereços salvos
- ✏️ Edição de endereços
- 🗑️ Exclusão de endereços
- 💅 Interface com Material Design e uso da fonte Roboto

## 🛠️ Tecnologias utilizadas

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [ViaCEP API](https://viacep.com.br/)

## 📂 Estrutura do Projeto

```plaintext
lib/
├── models/
│   └── endereco.dart
└── services/
    └── viacep_service.dart
    └── main.dart
