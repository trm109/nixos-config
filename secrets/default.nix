{ _ }:
{
  age.secrets = {
    teslamate_encryption_key.file = ./teslamate/encryption_key.age;
    teslamate_refresh_token.file = ./teslamate/refresh_token.age;
  };
}
