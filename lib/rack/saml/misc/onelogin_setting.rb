module Rack
  class Saml
    module OneloginSetting
      require 'ruby-saml'

      def saml_settings
        settings = OneLogin::RubySaml::Settings.new
        settings.assertion_consumer_service_url = @config['assertion_consumer_service_uri']
        settings.issuer = @config['saml_sp']
        settings.idp_sso_target_url = @metadata['saml2_http_redirect']
        settings.idp_cert = @metadata['certificate']
        settings.name_identifier_format = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient"
        #settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

        if @config['certificate'] && @config['private_key']
          settings.certificate = ::File.read(@config['certificate'])
          settings.private_key = ::File.read(@config['private_key'])

          settings.security[:authn_requests_signed] = true
          settings.security[:logout_requests_signed] = true
          settings.security[:logout_responses_signed] = true
          settings.security[:metadata_signed] = true

          settings.security[:digest_method] = XMLSecurity::Document::SHA1
          settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA1

          settings.security[:embed_sign] = true
        end

        settings
      end
    end
  end
end
