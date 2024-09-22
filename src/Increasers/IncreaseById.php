<?php

namespace Alves\Firebird\Increasers;

/**
 * IncreaseById
 *
 * @author Anderson Alves <fale_com_lopez@hotmail.com>
 * @version 1.0.0
 * @package Alves\Firebird\Increasers
 */
class IncreaseById
{
    protected string $sql;

    public function __construct(string $keyName, string $tableName)
    {
        $this->sql = 'SELECT COALESCE(MAX('. $keyName .'), 0) + 1 as CODIGO FROM ' . $tableName;
    }

    public function __toString(): string
    {
        return $this->sql;
    }
}