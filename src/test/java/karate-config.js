function fn() {
  var env = karate.env || 'dev';
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    port_marvel_characters_api: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  };
  // Microservicio Marvel Characters API
  config.port_marvel_characters_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  if (env == 'dev') {
    config.baseUrl = 'https://api-dev.empresa.com';
    config.port_marvel_characters_api = 'https://bp-se-test-cabcd9b246a5.herokuapp.com';
  } else if (env == 'qa') {
    config.baseUrl = 'https://api-qa.empresa.com';
    config.port_marvel_characters_api = 'https://bp-se-test-cabcd9b246a5.herokuapp.com';
  }
  return config;
}
