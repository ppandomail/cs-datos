# Becas RCI

* Las Universidades extranjeras conceden un número de becas para cada uno de los cursos que dictan, por ello el Instituto de Orientación al Estudiante guarda registro de las becas disponibles en todo el mundo.
* Cada beca tiene un código de identificación único dado por cada universidad extranjera y puede incluir varios cursos.
* Cada universidad tiene un código de identificación único de carácter internacional, sus otros datos son: el país al que pertenece, el nombre de la universidad, los teléfonos y el domicilio de la universidad.
* De los cursos interesa su código de identificación (asignado por cada universidad), el nombre del curso, la fecha de dictado, la beca ofrecida y el número de becas disponibles, el responsable del curso, el domicilio del responsable y todos sus títulos.
* De cada beca se desea conocer el tipo de beca (total, parcial, individual, grupal), el nombre de la beca, el monto de la beca y las características que pueden variar entre 1 y 15 (están definidas a través de un código único y de una descripción).
 
```mermaid
erDiagram
    BECAS }|--|| TIPO_BECA : tiene
    BECAS ||--}| CARACT_BECA : tiene
    BECAS }|--}| CURSOS : tiene
    BECAS }|--|| UNIVERSIDADES : tiene
    BECAS {
      int     beca_id PK
      string  beca_nombre
      float   beca_monto
      int     universidad_id FK
      int     tipo_beca_id FK
    }
    TIPO_BECA {
        int    tipo_beca_id PK
        string tipo_beca_nombre "{total, parcial, individual, grupal}"
    }
    CARACT_BECA {
        int    caract_beca_id PK
        string caract_beca_descripcion
    }
    CURSOS }|--|| RESPONSABLES : dictado
    CURSOS {
        int    curso_id PK
        string curso_nombre 
        date   curso_fecha_dictado
        int    becas_disponibles
        int    universidad_id FK
        int    responsable_id FK
    }
    RESPONSABLES }|--}| TITULOS : tiene
    RESPONSABLES {
        int    responsable_id PK
        string responsable_nombre
        string responsable_domicilio
    }
    TITULOS {
        int    titulo_id PK
        string titulo_nombre
    }
    UNIVERSIDADES }o--|| PAISES : tiene
    UNIVERSIDADES ||--}| CURSOS : dicta
    UNIVERSIDADES {
        int    universidad_id PK
        string universidad_nombre
        int    universidad_telefono
        int    universidad_fax
        int    pais_id FK
    }
    PAISES {
        int    pais_id PK
        string pais_nombre
    }
    
```
