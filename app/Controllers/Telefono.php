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

    public function create()
    {
        $entrada = json_decode($this->request->getBody());

        if (json_last_error() !== JSON_ERROR_NONE || !is_object($entrada)) {
            return $this->failValidationErrors('Envia un objeto JSON valido.');
        }

        $datos = [
            'idpersona' => $entrada->idpersona ?? null,
            'numero' => $entrada->numero ?? null,
            'tipo' => $entrada->tipo ?? 'Celular',
        ];

        if (
            !(is_int($datos['idpersona']) || is_string($datos['idpersona']))
            || !is_string($datos['numero'])
            || !is_string($datos['tipo'])
        ) {
            return $this->failValidationErrors(
                'idpersona debe ser un entero; numero y tipo deben ser textos.'
            );
        }

        $datos['numero'] = trim($datos['numero']);
        $datos['tipo'] = trim($datos['tipo']);

        $id = $this->model->insert($datos);

        if ($id === false) {
            return $this->failValidationErrors($this->model->errors());
        }

        return $this->respondCreated($this->model->find($id));
    }

    public function update($id = null)
    {
        if ($id === null || !ctype_digit((string) $id) || (int) $id < 1) {
            return $this->failValidationErrors('El ID debe ser un entero positivo.');
        }

        $telefono = $this->model->find($id);

        if ($telefono === null) {
            return $this->failNotFound('El telefono no existe.');
        }

        $entrada = json_decode($this->request->getBody());

        if (json_last_error() !== JSON_ERROR_NONE || !is_object($entrada)) {
            return $this->failValidationErrors('Envia un objeto JSON valido.');
        }

        $cambios = array_intersect_key(
            (array) $entrada,
            array_flip(['idpersona', 'numero', 'tipo'])
        );

        if ($cambios === []) {
            return $this->failValidationErrors(
                'Envia idpersona, numero o tipo para actualizar.'
            );
        }

        $datos = array_replace(
            array_intersect_key(
                $telefono,
                array_flip(['idpersona', 'numero', 'tipo'])
            ),
            $cambios
        );

        if (
            !(is_int($datos['idpersona']) || is_string($datos['idpersona']))
            || !is_string($datos['numero'])
            || !is_string($datos['tipo'])
        ) {
            return $this->failValidationErrors(
                'idpersona debe ser un entero; numero y tipo deben ser textos.'
            );
        }

        $datos['numero'] = trim($datos['numero']);
        $datos['tipo'] = trim($datos['tipo']);

        if (!$this->model->update($id, $datos)) {
            return $this->failValidationErrors($this->model->errors());
        }

        return $this->respond($this->model->find($id));
    }

    public function delete($id = null)
    {
        if ($id === null || !ctype_digit((string) $id) || (int) $id < 1) {
            return $this->failValidationErrors('El ID debe ser un entero positivo.');
        }

        $telefono = $this->model->find($id);

        if ($telefono === null) {
            return $this->failNotFound('El telefono no existe.');
        }

        if (!$this->model->delete($id)) {
            return $this->failServerError('No se pudo eliminar el telefono.');
        }

        return $this->respondDeleted([
            'mensaje' => 'Telefono eliminado correctamente.',
            'idtelefono' => (int) $id,
        ]);
    }
}
