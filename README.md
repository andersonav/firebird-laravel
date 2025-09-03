Laravel Firebird
===

Package desenvolvido para realizar uma melhor integração entre o Firebird
e os models *Eloquent* do *Laravel*

Este package corrige a falta de `reconnector`, necessário nas versões mais novas do Laravel,
além de permitir o uso do `auto increment`, seja por generator, seja por incremento
manual da chave primária.

Instalação
---
Para utilização deste package, fazer a instalação via composer:

```bash
$ composer require alves/firebird-laravel
```

Após a instalação, os models devem extender a uma nova classe.

```php
<?php

namespace App\Models;

use Alves\Firebird\FirebirdModel;

class User extends FirebirdModel
{
    protected $primaryKey = 'ID';

    protected $generator = 'GEN_USERS';
}
```

É valido lembrar que, por padrão, as colunas em um banco de dados firebird
são retornadas em *UPPER CASE*. Neste caso, é importante setar a `primary key`
para que o model possa funcionar corretamente.

Caso o model não possua um generator definido, o model irá gerar um ID automaticamente,
baseado no último id + 1;