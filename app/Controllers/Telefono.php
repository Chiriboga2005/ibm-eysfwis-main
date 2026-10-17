<?php

namespace App\Controllers;

use CodeIgniter\RESTful\ResourceController;

class Telefono extends ResourceController
{
    protected $modelName = 'App\Models\TelefonoModel';
    protected $format = 'json';

    public function index()
    {
        $telefonos = $this->model
            ->orderBy('idtelefono', 'DESC')
            ->findAll();

        return $this->respond($telefonos);
    }

    public function show($id = null)
    {
        if ($id === null || !ctype_digit((string) $id) || (int) $id < 1) {
            return $this->failValidationErrors('El ID debe ser un entero positivo.');
        }

        $telefono = $this->model->find($id);

        if ($telefono === null) {
            return $this->failNotFound('El telefono no existe.');
        }

        return $this->respond($telefono);
    }
}