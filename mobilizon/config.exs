# Mobilizon instance configuration

import Config

listen_ip = System.get_env("MOBILIZON_INSTANCE_LISTEN_IP", "0.0.0.0")

listen_ip =
  case listen_ip |> to_charlist() |> :inet.parse_address() do
    {:ok, listen_ip} -> listen_ip
    _ -> raise "MOBILIZON_INSTANCE_LISTEN_IP does not match the expected IP format."
  end

config :mobilizon, Mobilizon.Web.Endpoint,
  server: true,
  url: [host: System.get_env("MOBILIZON_INSTANCE_HOST", "mobilizon.lan")],
  http: [
    port: String.to_integer(System.get_env("MOBILIZON_INSTANCE_PORT", "4000")),
    ip: listen_ip
  ],
  secret_key_base: System.get_env("MOBILIZON_INSTANCE_SECRET_KEY_BASE", "changethis")

config :mobilizon, Mobilizon.Web.Auth.Guardian,
  secret_key: System.get_env("MOBILIZON_INSTANCE_SECRET_KEY", "changethis")

config :mobilizon, :instance,
  name: System.get_env("MOBILIZON_INSTANCE_NAME", "Mobilizon"),
  description: "Change this to a proper description of your instance",
  hostname: System.get_env("MOBILIZON_INSTANCE_HOST", "mobilizon.lan"),
  registrations_open: System.get_env("MOBILIZON_INSTANCE_REGISTRATIONS_OPEN", "false") == "true",
  demo: false,
  allow_relay: true,
  federating: true,
  email_from: System.get_env("MOBILIZON_INSTANCE_EMAIL", "noreply@mobilizon.lan"),
  email_reply_to: System.get_env("MOBILIZON_REPLY_EMAIL", "noreply@mobilizon.lan")

config :mobilizon, Mobilizon.Storage.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("MOBILIZON_DATABASE_USERNAME", "username"),
  password: System.get_env("MOBILIZON_DATABASE_PASSWORD", "password"),
  database: System.get_env("MOBILIZON_DATABASE_DBNAME", "mobilizon"),
  hostname: System.get_env("MOBILIZON_DATABASE_HOST", "postgres"),
  port: 5432,
  pool_size: 10

config :mobilizon, Mobilizon.Web.Email.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: System.get_env("MOBILIZON_SMTP_SERVER", "localhost"),
  port: System.get_env("MOBILIZON_SMTP_PORT", "25"),
  username: System.get_env("MOBILIZON_SMTP_USERNAME", nil),
  password: System.get_env("MOBILIZON_SMTP_PASSWORD", nil),
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: System.get_env("MOBILIZON_SMTP_SSL", "false"),
  retries: 1,
  no_mx_lookups: false,
  auth: :if_available

config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: "/var/lib/mobilizon/geo_db/GeoLite2-City.mmdb"
    }
  ]

config :mobilizon, Mobilizon.Web.Upload.Uploader.Local,
  uploads: System.get_env("MOBILIZON_UPLOADS", "/var/lib/mobilizon/uploads")

config :mobilizon, :exports,
  path: System.get_env("MOBILIZON_UPLOADS_EXPORTS", "/var/lib/mobilizon/uploads/exports"),
  formats: [
    Mobilizon.Service.Export.Participants.CSV,
    Mobilizon.Service.Export.Participants.PDF,
    Mobilizon.Service.Export.Participants.ODS
  ]

config :tz_world,
  data_dir: System.get_env("MOBILIZON_TIMEZONES_DIR", "/var/lib/mobilizon/timezones")


#
# keycloak config for hackerspace.zone self hosted single-sign-on
#
keycloak_hostname = System.get_env("KEYCLOAK_HOSTNAME", "keycloak.example.com")
keycloak_realm = System.get_env("REALM", "example")
keycloak_secret = System.get_env("MOBILIZON_CLIENT_SECRET", "abcdef1234")
keycloak_url = "https://#{keycloak_hostname}/realms/#{keycloak_realm}"

config :ueberauth,
       Ueberauth,
       providers: [
         keycloak: {Ueberauth.Strategy.Keycloak, [default_scope: "openid"]}
       ]

config :mobilizon, :auth,
  oauth_consumer_strategies: [
    {:keycloak, "#{keycloak_hostname}"}
  ]

config :ueberauth, Ueberauth.Strategy.Keycloak.OAuth,
  client_id: "mobilizon",
  client_secret: keycloak_secret,
  site: keycloak_url,
  authorize_url: "#{keycloak_url}/protocol/openid-connect/auth",
  token_url: "#{keycloak_url}/protocol/openid-connect/token",
  userinfo_url: "#{keycloak_url}/protocol/openid-connect/userinfo",
  token_method: :post
