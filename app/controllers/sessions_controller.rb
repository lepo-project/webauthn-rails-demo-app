class SessionsController < ApplicationController


  def new
  end

  def create
    credential_creation_options = WebAuthn.credential_creation_options
    credential_creation_options[:attestation] = "direct"

    session[:challenge] = credential_creation_options[:challenge]

    @credential_creation_options = credential_creation_options
    respond_to :js
  end

  def callback
    attestation_response = WebAuthn::AuthenticatorAttestationResponse.new(
      attestation_object: params[:response][:attestationObject],
      client_data_json: params[:response][:clientDataJSON]
    )

    if attestation_response.valid?(session[:challenge], request.base_url)
      render json: { status: "ok" }, status: :ok
    else
      render json: { status: "forbidden"}, status: :forbidden
    end
  end
end
