@REQ_HU-EvalPC001 @HU001 @marvel_characters_crud @marvel_characters_api @Agente2 @E2 @iniciativa_marvel_api
Feature: HU-EvalPC001 CRUD de personajes Marvel (microservicio para gestión de personajes)
  Evaluacion de automatización de pruebas de API con Karate para el CRUD de personajes Marvel.
  Autor: pjcarden - Paola Cardenas
  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @obtenerPersonajes @structureValidation200
  Scenario: T-API-HU-EvalPC001-CA01-Obtener lista vacía de personajes 200 - karate
    Given path 'testuser', 'api', 'characters'
    When method GET
    Then status 200
    * def schema = karate.read('classpath:data/marvel_characters_api/response_character_schema.json')
    * if (response.length > 0) karate.match(response[0], schema)


  @id:2 @obtenerPersonajePorId @exitoso200
  Scenario: T-API-HU-EvalPC001-CA02-Obtener personaje por ID exitoso 200 - karate (Si falla alguien borro mi Doraemon :/)
    * def id_character = 1873
    * def name_character = 'Doraemon'
    Given path 'testuser', 'api', 'characters', id_character
    When method GET
    Then status 200
    And match response.id == id_character
    And match response.name == name_character

  @id:3 @obtenerPersonajePorId @noEncontrado404
  Scenario: T-API-HU-EvalPC001-CA03-Obtener personaje por ID no existe 404 - karate
    * def id_character = -999
    Given path 'testuser', 'api', 'characters', id_character
    When method GET
    Then status 404
    And match response == karate.read('classpath:data/marvel_characters_api/response_get_character_404.json')

  @id:4 @crearPersonaje @exitoso201
  Scenario: T-API-HU-EvalPC001-CA04-Crear personaje exitosamente 201 - karate
    * def uuid = java.util.UUID.randomUUID() + ''
    * def personaje = karate.read('classpath:data/marvel_characters_api/request_create_character.json')
    * personaje.name = personaje.name + '_' + uuid
    Given path 'testuser', 'api', 'characters'
    And request personaje
    When method POST
    Then status 201
    And match response.name contains uuid
    And match response.id != null

  @id:5 @crearPersonaje @nombreDuplicado400
  Scenario: T-API-HU-EvalPC001-CA05-Crear personaje con nombre duplicado 400 - karate
    Given path 'testuser', 'api', 'characters'
    And request karate.read('classpath:data/marvel_characters_api/request_create_character_duplicate.json')
    When method POST
    Then status 400
    And match response == karate.read('classpath:data/marvel_characters_api/response_create_character_400_duplicate.json')

  @id:6 @crearPersonaje @faltanCampos400
  Scenario: T-API-HU-EvalPC001-CA06-Crear personaje faltan campos requeridos 400 - karate
    Given path 'testuser', 'api', 'characters'
    And request karate.read('classpath:data/marvel_characters_api/request_create_character_missing_fields.json')
    When method POST
    Then status 400
    And match response.name == 'Name is required'

  @id:7 @actualizarPersonaje @exitoso200
  Scenario: T-API-HU-EvalPC001-CA07-Actualizar personaje exitosamente 200 - karate
    * def id_character = 1873
    Given path 'testuser', 'api', 'characters', id_character
    And request karate.read('classpath:data/marvel_characters_api/request_update_character.json')
    When method PUT
    Then status 200
    And match response.id == id_character

  @id:8 @actualizarPersonaje @noEncontrado404
  Scenario: T-API-HU-EvalPC001-CA08-Actualizar personaje no existe 404 - karate
    Given path 'testuser', 'api', 'characters', -999
    And request karate.read('classpath:data/marvel_characters_api/request_update_character.json')
    When method PUT
    Then status 404
    And match response == karate.read('classpath:data/marvel_characters_api/response_update_character_404.json')

  @id:9 @crearYEliminarPersonaje @flujoCompleto
  Scenario: T-API-HU-EvalPC001-CA04-Crear y eliminar personaje exitosamente - karate
    * def uuid = java.util.UUID.randomUUID() + ''
    * def personaje = karate.read('classpath:data/marvel_characters_api/request_create_character.json')
    * personaje.name = personaje.name + '_' + uuid
    Given path 'testuser', 'api', 'characters'
    And request personaje
    When method POST
    Then status 201
    And match response.name contains uuid
    And match response.id != null
    * def id_creado = response.id
    # Eliminar el personaje creado
    Given path 'testuser', 'api', 'characters', id_creado
    When method DELETE
    Then status 204
    # And match response == ''
    # And match response == karate.read('classpath:data/marvel_characters_api/response_delete_character_204.json')

  @id:10 @eliminarPersonaje @noEncontrado404
  Scenario: T-API-HU-EvalPC001-CA10-Eliminar personaje no existe 404 - karate
    Given path 'testuser', 'api', 'characters', -999
    When method DELETE
    Then status 404
    And match response == karate.read('classpath:data/marvel_characters_api/response_delete_character_404.json')
