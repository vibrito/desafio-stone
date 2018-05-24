# README #

Resposta ao Desafio da Stone em Objective-C. 

## Gerenciador de dependências ##

* [CocoaPods](https://cocoapods.org/)

## Frameworks ##

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [Realm](https://realm.io)
* [MBProgressHud](https://github.com/jdg/MBProgressHUD)

## Automatização ##

* [Fastlane](https://fastlane.tools)

## Testes ##

* [XCTest](https://developer.apple.com/documentation/xctest)

## O que falta? ##

* Melhor tratamento do teclado, que atualmente esconde alguns compontes em algumas telas.
* Implementar o "Esqueci Senha"

## Instalação do projeto

Caso exista uma versão anterior do projeto instalada no simulador ou dispositivo, por favor remova essa versão e proceda com uma instalação limpa. Isso também é válido para os testes. 

## Utilizando os testes ##

Abra o projeto e com XCode carregado, aperte Shift + Command + U

### O que podemos testar?

Atualmente somente o processo de login com sucesso e com erro e registro com sucesso e erro são contemplados pelos testes. Mais testes serão adicionados no futuro.

## Instalando o fastlane

![Mou icon](https://fastlane.tools/assets/img/logo-desktop-large.png)

Abra o terminal e coloque os seguintes comandos:
Para instalar o terminal no xcode
```
xcode-select --install
```

Para instalar fastlane
```
sudo gem install fastlane
```

Navegue até a pasta que contem o projeto e inicializa o fastlane
```
fastlane init
```

## Usando o fastlane

Foram implementadas duas funcionalidades automatizadas, rodar os testes e subir para o TestFlight as versões Betas. Mais funcionalidades serão implementadas no futuro. 

### Automatizando os testes

Para rodar somente os testes, abra o Simulator com o iPhone 8, iOS 11.3. Após, abra o terminal e navegue até a pasta que contem o projeto. Dentro dessa pasta digite o seguinte comando: 

```
fastlane test
```

### Automatizando o upload dos betas

Para subir a aplicação para o TestFlight abra o terminal e navegue até a pasta que contem o projeto. Dentro dessa pasta digite o seguinte comando: 

```
fastlane beta
```

Na primeira vez que o comando for iniciado, será pedido seu Apple ID com autorização para upload do aplicativo.  

### Automatizando os teste e logo após subir a aplicação para o TestFlight

Abra o Simulator com o iPhone 8, iOS 11.3. Após, abra o terminal e navegue até a pasta que contem o projeto. Dentro dessa pasta digite o seguinte comando: 

```
fastlane betaTest
```
