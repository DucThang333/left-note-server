defmodule LeftNoteServer.Token do
  use Joken.Config

  @private_key File.read!("private.pem")
  @public_key File.read!("public.pem")

  # Define default signer here
  def token_config do
    # token expires in 1 hour
    default_claims(default_exp: 3600 * 24 * 7)
  end

  def signer, do: Joken.Signer.create("RS256", %{"pem" => @private_key})
  def verifier, do: Joken.Signer.create("RS256", %{"pem" => @public_key})
end
