<?php

namespace Alves\Firebird\Increasers;

/**
 * IncreaseByGenerator
 *
 * @author Anderson Alves <fale_com_lopez@hotmail.com>
 * @version 1.0.0
 * @package Alves\Firebird\Increasers
 */
class IncreaseByGenerator
{
    protected string $sql;

    public function __construct(string $generator)
    {
        $this->sql = 'SELECT GEN_ID('. $generator .', 1) AS CODIGO FROM RDB$DATABASE';
    }

    public function __toString(): string
    {
        return $this->sql;
    }
}