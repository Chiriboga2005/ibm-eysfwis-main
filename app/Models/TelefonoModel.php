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

    protected $validationRules = [
        'idpersona' => 'required|is_natural_no_zero|is_not_unique[persona.idpersona]',
        'numero' => 'required|min_length[7]|max_length[20]|regex_match[/^\+?[0-9 ()-]+$/]',
        'tipo' => 'required|in_list[Celular,Fijo,Trabajo,Otro]',
    ];

    protected $validationMessages = [
        'idpersona' => [
            'required' => 'Debes seleccionar una persona.',
            'is_natural_no_zero' => 'El identificador de persona debe ser positivo.',
            'is_not_unique' => 'La persona seleccionada no existe.',
        ],
        'numero' => [
            'required' => 'El numero de telefono es obligatorio.',
            'min_length' => 'El telefono debe tener al menos 7 caracteres.',
            'max_length' => 'El telefono no puede superar 20 caracteres.',
            'regex_match' => 'Usa numeros, espacios, parentesis, guiones y un signo + inicial opcional.',
        ],
        'tipo' => [
            'required' => 'Debes indicar el tipo de telefono.',
            'in_list' => 'El tipo debe ser Celular, Fijo, Trabajo u Otro.',
        ],
    ];
}