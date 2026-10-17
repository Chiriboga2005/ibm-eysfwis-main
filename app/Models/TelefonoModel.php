<?php

namespace App\Models;

use CodeIgniter\Model;

class TelefonoModel extends Model
{
    protected $table = 'telefono';
    protected $primaryKey = 'idtelefono';
    protected $useAutoIncrement = true;
    protected $returnType = 'array';
    protected $protectFields = true;
    protected $allowedFields = ['idpersona', 'numero', 'tipo'];
    protected $useTimestamps = false;
}